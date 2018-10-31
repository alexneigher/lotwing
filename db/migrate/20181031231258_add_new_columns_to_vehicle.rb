class AddNewColumnsToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :stock_number, :string
    add_column :vehicles, :trim_level, :string
    add_column :vehicles, :doors, :string
    add_column :vehicles, :body_style, :string
    add_column :vehicles, :transmission, :string
    add_column :vehicles, :engine, :string
    add_column :vehicles, :engine_size, :string
    add_column :vehicles, :model_code, :string
    add_column :vehicles, :certified, :string
    add_column :vehicles, :retail_value, :string
    add_column :vehicles, :invoice_price, :string
    add_column :vehicles, :asking_price, :string
    add_column :vehicles, :wholesale_price, :string
    add_column :vehicles, :msrp, :string
    add_column :vehicles, :sale_price, :string
    add_column :vehicles, :vehicle_type, :string
    add_column :vehicles, :options, :string
    add_column :vehicles, :options_codes, :string
    add_column :vehicles, :comments, :string
    add_column :vehicles, :photo_url_list, :string
    add_column :vehicles, :package_code, :string
    add_column :vehicles, :fuel, :string
    add_column :vehicles, :drive_line, :string
    add_column :vehicles, :rear_wheel, :string
    add_column :vehicles, :status, :string
    add_column :vehicles, :raw_data_feed_output, :text
  end
end
