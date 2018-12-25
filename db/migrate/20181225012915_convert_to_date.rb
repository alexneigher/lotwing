class ConvertToDate < ActiveRecord::Migration[5.1]
  def change
    remove_column :check_requests, :request_date
    add_column :check_requests, :request_date, :date
  end
end
