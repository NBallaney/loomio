namespace :special_categories do
  # task create_categories: :environment do
  # 	# Default special categories
  #   categories = ["Forge Alliance", "Alliance Decision", "Increase Voting Power",
  #                 "Decrease Voting Power", "Invite Member", "Exile Member"]
  #   categories.each do |category|
  #     pc = PollCategory.find_or_initialize_by(name: category)
  #     default_values = {pass_percentage: 70, stop_percentage: 30,
  #                 active_days: 5, resubmission_active_days: 3,
  #                 pass_percentage_drop: 4, special: true} 
  #     pc.assign_attributes(default_values)
  #     if pc.save
  #       puts "Special Poll Category added: #{category}"
  #     else
  #     	puts "Error: #{pc.errors.full_messages.join(",")}"
  #     end
  #   end
  # end

  # task assign_to_groups: :environment do
  #   FormalGroup.all.each do |fg|
  #   	categories = fg.poll_categories
  #   	fg.poll_categories = categories + PollCategory.special
  #   	fg.save
  #     puts "Special Poll Categories added to group: #{fg.name}"
  #   rescue => e
  #    	puts "Error: #{e.inspect}"
  #   end
  # end

  task create_categories_for_groups: :environment do
    categories = ["Forge Alliance", "Alliance Decision", "Increase Voting Power",
                  "Decrease Voting Power", "Invite Member", "Exile Member"]
    FormalGroup.all.each do |fg|
      categories.each do |category|
      	if new_cat = fg.poll_categories.create(name: category, pass_percentage: 70,
      	                          stop_percentage: 30, active_days: 5, resubmission_active_days: 3,
      	                          pass_percentage_drop: 4, special: true)
      	  puts "Special Poll Category- #{category} added to group: #{fg.name}"
        else
     	    puts "Error: #{new_cat.errors.full_messages.join(", ")}"
     	  end
      end
    end
  end
end