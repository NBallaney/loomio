class PollService
  def self.create(poll:, actor:)
    actor.ability.authorize! :create, poll

    poll.assign_attributes(author: actor)

    return false unless poll.valid?
    poll.save!

    EventBus.broadcast('poll_create', poll, actor)
    Events::PollCreated.publish!(poll, actor)
  end

  def self.close(poll:, actor:)
    actor.ability.authorize! :close, poll
    do_closing_work(poll: poll)
    EventBus.broadcast('poll_close', poll, actor)
    Events::PollClosedByUser.publish!(poll, actor)
  end

  def self.reopen(poll:, params:, actor:)
    actor.ability.authorize! :reopen, poll

    poll.assign_attributes(closing_at: params[:closing_at], closed_at: nil)
    return false unless poll.valid?

    poll.save!
    poll.poll_did_not_votes.delete_all
    poll.update_undecided_count

    EventBus.broadcast('poll_reopen', poll, actor)
    Events::PollReopened.publish!(poll, actor)
  end

  def self.resubmit(poll:, params:, actor:)
    #actor.ability.authorize! :reopen, poll

    status = poll.status
    new_poll = poll.build_child_poll(poll.attributes.slice("author_id", "title", "details", "poll_type", "stop_percentage", "resubmission_active_days", "pass_percentage_drop", "poll_category_id"))
    parameters = {pass_percentage: (poll.pass_percentage  - poll.pass_percentage_drop),
                  closing_at: (Time.now + poll.resubmission_active_days.to_i.days),
                  resubmission_count: (poll.resubmission_count + 1), status: nil,
                  closed_at: nil, poll_option_names: poll.poll_option_names} 
    new_poll.assign_attributes(params.merge parameters)
    poll.assign_attributes(resubmission_count: (poll.resubmission_count + 1))
    valid = poll.valid? && new_poll.valid?
    new_poll.errors[:base] << "Proposal cannot be resubmitted because of disagree vote count." if status == "Stop"
    poll.errors[:base] << "Proposal cannot be resubmitted because of disagree vote count." if status == "Stop"
    return new_poll unless( valid && (status != "Stop"))

    new_poll.save!
    poll.save!#update_colums(resubmission_count: new_poll.resubmission_count )
    #EventBus.broadcast('poll_create', new_poll, actor)
    #Events::PollCreated.publish!(new_poll, actor)
  end

  def self.publish_closing_soon
    hour_start = 1.day.from_now.at_beginning_of_hour
    hour_finish = hour_start + 1.hour
    this_hour_tomorrow = hour_start..hour_finish
    Poll.closing_soon_not_published(this_hour_tomorrow).each do |poll|
      Events::PollClosingSoon.publish!(poll)
    end
  end

  def self.expire_lapsed_polls
    Poll.lapsed_but_not_closed.each do |poll|
      do_closing_work(poll: poll)
      EventBus.broadcast('poll_expire', poll)
      Events::PollExpired.publish!(poll)
    end
  end

  def self.do_closing_work(poll:)
    #poll.update(closed_at: Time.now) unless poll.closed_at.present?
    determine_status poll
    poll.poll_did_not_votes.delete_all
    poll.poll_did_not_votes.import poll.undecided.map { |user| PollDidNotVote.new(user: user, poll: poll) }, validate: false
    poll.update(closed_at: Time.now) unless poll.closed_at.present?
    poll.update_undecided_count
  end

  def self.determine_status poll
    agree_count, disagree_count,others_count = poll.get_stance_count
    total_votes = agree_count + disagree_count + others_count
    agree_percentage = (agree_count.to_f/total_votes)*100
    disagree_percentage = (disagree_count.to_f/total_votes)*100
    if agree_percentage >= poll.pass_percentage
      poll.update_attributes(status: 0)
    elsif disagree_percentage >= poll.stop_percentage
      poll.update_attributes(status: 1)
    else
      poll.update_attributes(status: 2)
    end
  end

  def self.update(poll:, params:, actor:)
    actor.ability.authorize! :update, poll
    poll.assign_attributes(params.except(:poll_type, :discussion_id))
    is_new_version = poll.is_new_version?

    return false unless poll.valid?
    poll.save!

    EventBus.broadcast('poll_update', poll, actor)
    Events::PollEdited.publish!(poll, actor) if is_new_version
  end

  def self.add_options(poll:, params:, actor:)
    actor.ability.authorize! :add_options, poll
    option_names = Array(params[:poll_option_names]) - poll.poll_option_names
    poll.poll_option_names += option_names

    return false unless poll.valid?
    poll.save!

    EventBus.broadcast('poll_add_options', poll, actor, params)
    Events::PollOptionAdded.publish!(poll, actor, option_names)
  end

  def self.destroy(poll:, actor:)
    actor.ability.authorize! :destroy, poll
    poll.destroy

    EventBus.broadcast('poll_destroy', poll, actor)
  end

  def self.toggle_subscription(poll:, actor:)
    actor.ability.authorize! :toggle_subscription, poll

    unsubscription = poll.poll_unsubscriptions.find_or_initialize_by(user: actor)
    if unsubscription.persisted?
      unsubscription.destroy
    else
      unsubscription.save!
    end

    EventBus.broadcast('poll_toggle_subscription', poll, actor)
  end

  def self.cleanup_examples
    Poll.where(example: true).where('created_at < ?', 1.day.ago).destroy_all
  end

end
