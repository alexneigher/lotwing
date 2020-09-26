class DropJobsPlaceholder < ActiveRecord::Migration[5.1]
  def change
    remove_column :detail_jobs, :jobs
  end
end
