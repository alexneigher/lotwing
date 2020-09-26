class AddOptionalTasksToDetailJobos < ActiveRecord::Migration[5.1]
  def change
    add_column :detail_jobs, :add_dealership_default_task_1, :boolean, default: true
    add_column :detail_jobs, :add_dealership_default_task_2, :boolean, default: false
    add_column :detail_jobs, :add_dealership_default_task_3, :boolean, default: false
    add_column :detail_jobs, :add_dealership_default_task_4, :boolean, default: false

    add_column :detail_jobs, :custom_task, :string
  end
end
