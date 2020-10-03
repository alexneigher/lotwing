class AddPauseInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :detail_jobs, :is_paused, :boolean, default: false
    add_column :detail_jobs, :pause_duration_seconds, :integer, default: 0
    add_column :detail_jobs, :most_recently_paused_at, :datetime
  end
end
