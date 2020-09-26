class CreateDealershipConfigurations < ActiveRecord::Migration[5.1]
  def change
    create_table :dealership_configurations do |t|
      t.references :dealership, foreign_key: true

      t.string :detail_board_task_1
      t.string :detail_board_task_2
      t.string :detail_board_task_3
      t.string :detail_board_task_4
      t.string :detail_board_default_job_duration

      t.boolean :show_detail_job_link_in_ui, default: true
      t.boolean :allow_sales_reps_to_create_detail_jobs, default: false

      t.timestamps
    end
  end
end
