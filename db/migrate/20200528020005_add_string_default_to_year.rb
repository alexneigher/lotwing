class AddStringDefaultToYear < ActiveRecord::Migration[5.1]
  def change
    change_column :vehicles, :year, :string, default: ""
  end
end
