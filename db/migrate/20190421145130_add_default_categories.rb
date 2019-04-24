class AddDefaultCategories < ActiveRecord::Migration[5.1]
  def change
  	categories = ["Modify Consensus Thresholds", "Alliance Parent Decision"]
  	FormalGroup.published.each do |group|
    	categories.each do |category|
        group.poll_categories.create(name: category, pass_percentage: 70,
                                    stop_percentage: 30, active_days: 5, resubmission_active_days: 3,
                                    pass_percentage_drop: 4, special: true)
      end
    end
  end
end
