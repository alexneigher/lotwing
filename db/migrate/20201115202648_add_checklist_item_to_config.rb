class AddChecklistItemToConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :dealership_configurations, :include_check_for_test_drives_longer_than, :integer
  end
end
