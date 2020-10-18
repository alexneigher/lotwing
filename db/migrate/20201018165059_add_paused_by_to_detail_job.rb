class AddPausedByToDetailJob < ActiveRecord::Migration[5.1]
  def change
    add_reference :detail_jobs, :most_recently_paused_by_user
  end
end
