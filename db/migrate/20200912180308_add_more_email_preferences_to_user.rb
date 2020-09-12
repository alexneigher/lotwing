class AddMoreEmailPreferencesToUser < ActiveRecord::Migration[5.1]

  def change
    add_column :email_preferences, :service_department_email, :boolean, default: :false
    add_column :email_preferences, :collision_department_email, :boolean, default: :false
    add_column :email_preferences, :parts_department_email, :boolean, default: :false
  end

end
