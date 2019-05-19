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

    poll.assign_attributes(closed_at: nil)
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
    new_poll = poll.build_child_poll(poll.attributes.slice("author_id", "title", "details", "poll_type", "stop_percentage", "resubmission_active_days", "pass_percentage_drop", "poll_category_id", "group_id"))
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
    new_poll
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
    determine_status(poll) if poll.poll_type == "proposal"
    special_categories_hook(poll) if poll.poll_type == "proposal"
    poll.poll_did_not_votes.delete_all
    poll.poll_did_not_votes.import poll.undecided.map { |user| PollDidNotVote.new(user: user, poll: poll) }, validate: false
    poll.update(closed_at: Time.now) unless poll.closed_at.present?
    poll.update_undecided_count
  end

  # Determine poll status based on votes
  def self.determine_status poll
    agree_count, disagree_count, others_count = poll.get_stance_count
    agree_count, disagree_count, others_count = check_child_poll_votes poll, agree_count, disagree_count, others_count
    total_votes = agree_count + disagree_count + others_count
    if total_votes > 0 && (agree_count > 0 || disagree_count > 0)
      agree_percentage = (agree_count.to_f/total_votes)*100
      disagree_percentage = (disagree_count.to_f/total_votes)*100
      majority = [agree_percentage, disagree_percentage].max
      majority_value = (agree_percentage > disagree_percentage) ? "yes" : "no"
    end
    if majority && (majority >= poll.pass_percentage)
      poll.update_attributes(status: 0, majority: majority_value)
    #elsif disagree_percentage >= poll.stop_percentage
    elsif majority && (majority <= poll.stop_percentage)
      poll.update_attributes(status: 1)
    else
      poll.update_attributes(status: 2)
    end
  end

  # Check child poll votes(if any) to determine the poll status
  def self.check_child_poll_votes poll, agree_count, disagree_count, others_count
    #agree_count, disagree_count, others_count = 0, 0, 0
    #poll.alliance_decision_child_polls.each do |child_poll|
    poll.child_group_polls.each do |child_poll|
      if child_poll.closed?
        case child_poll.status
        when "Pass"
          agree_count += 1
        when "Stop"
          disagree_count += 1
        else
          others_count += 1
        end
      else
        others_count += 1
      end
    end
    return agree_count, disagree_count, others_count
  end

  def self.special_categories_hook poll
    case poll.poll_category.name
    when "Forge Alliance"
      if poll.alliance_parent_id
        if poll.status == "Pass" && poll.majority =="yes"
          parent_poll = poll.alliance_decision_parent_poll
          is_parent = parent_poll.additional_data["parent"].present?
          if is_parent
            GroupMembership.create(parent_group_id: poll.group_id, child_group_id: parent_poll.group_id)
          else
            GroupMembership.create(parent_group_id: parent_poll.group_id, child_group_id: poll.group_id)
          end
        end
      else
        if poll.status == "Pass" && poll.majority =="yes"
          is_parent = poll.additional_data["parent"].present?
          title = is_parent ? "Child Group Invitation: #{poll.title}" : "Parent Group Invitation: #{poll.title}"
          group = Group.find(poll.additional_data["group_id"])
          category = group.poll_categories.where(name: "Forge Alliance").first
            #"pass_percentage", "stop_percentage", "resubmission_active_days", 
            #"pass_percentage_drop", "poll_category_id")
          attributes = poll.attributes.slice("author_id", "title", "details", "poll_type")
            .merge({title: title, group_id: group.id, poll_category_id: category.id,
                    poll_option_names: ["agree", "abstain", "disagree", "block"]})
          poll.create_alliance_child_poll(attributes)
        end
      end
    when "Alliance Decision"
    when "Increase Voting Power"
      data = poll.additional_data
      if poll.status == "Pass" && poll.majority =="yes"
        if data["member_type"] == "group"
          pg = PowerGroup.find_or_initialize_by(parent_id: poll.group_id, group_id: data["group_id"])
          if(data["vote_power"].to_i > 1)
            pg.vote_power = data["vote_power"]
            pg.save
          end
        elsif data["member_type"] == "user"
          pu = PowerUser.find_or_initialize_by(user_id: data["user_id"], group_id: poll.group_id)
          if(data["vote_power"].to_i > 1)
            pu.vote_power = data["vote_power"]
            pu.save
          end
        end
      end
    when "Decrease Voting Power"
      data = poll.additional_data
      if poll.status == "Pass" && poll.majority =="yes"
        if data["member_type"] == "group"
          pg = PowerGroup.find_by(parent_id: poll.group_id, group_id: data["group_id"])
          if( pg && (data["vote_power"].to_i > 0))
            pg.vote_power = data["vote_power"]
            pg.save
          end
        elsif data["member_type"] == "user"
          pu = PowerUser.find_by(user_id: data["user_id"], group_id: poll.group_id)
          if( pu && (data["vote_power"].to_i > 0))
            pu.vote_power = data["vote_power"]
            pu.save
          end
        end
      end
    when "Invite Member"
      if poll.status == "Pass" && poll.majority =="yes"
        notified_model = poll.group
        params = {:recipients => {}}
        params[:recipients][:user_ids] = JSON.parse( poll.additional_data["user_ids"])
        params[:recipients][:emails] = JSON.parse( poll.additional_data["emails"])
        params[:kind] = "group_announced"
        AnnouncementService.create(model: notified_model, params: params, actor: poll.user)
      end
    when "Exile Member"
      data = poll.additional_data
      if poll.status == "Pass" && poll.majority =="yes"
        if data["member_type"] == "user"
          data = poll.additional_data
          user_id = data["user_id"]
          membership = Membership.find_by(group_id: poll.group_id,user_id: user_id)
          membership.destroy if membership
        elsif data["member_type"] == "group"
          data = poll.additional_data
          group_id = data["group_id"]
          membership = GroupMembership.find_by(parent_group_id: poll.group_id,child_group_id: group_id)
          membership.destroy if membership
        end
      end
    when "Modify Consensus Thresholds"
      if poll.status == "Pass" && poll.majority =="yes"
        data = poll.additional_data
        poll_category = poll.group.poll_categories.find_by(id: data["poll_category_id"])
        poll_category.attributes = data.slice("active_days","pass_percentage", "stop_percentage", "pass_percentage_drop", "resubmission_active_days") if poll_category
        poll_category.save
      end
    when "Alliance Parent Decision"
      if poll.status == "Pass" && poll.majority =="yes"
        data = poll.additional_data
        #parent_group = FormalGroup.find(data["group_id"])
        #poll_category = parent_group.poll_categories.find(data["poll_category_id"])
        addn_data = data["apd_data1"].dup
        addn_data["apd_data1"] = data["apd_data2"].try(:dup) || {}
        attributes = poll.attributes.slice("author_id", "title", "details", "poll_type")
                      .merge({title: poll.title, details: poll.details, group_id: data["group_id"], 
                           poll_category_id: data["poll_category_id"], additional_data: addn_data,
                           poll_option_names: ["agree", "abstain", "disagree", "block"]})
        parent_poll = poll.build_alliance_parent_decision_poll(attributes)
        parent_poll.save
        # poll_category = poll.group.poll_categories.find_by(id: data["poll_category_id"])
        # poll_category.attributes = data.slice("active_days","pass_percentage", "stop_percentage", "pass_percentage_drop", "resubmission_active_days") if poll_category
        # poll_category.save
      end
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
