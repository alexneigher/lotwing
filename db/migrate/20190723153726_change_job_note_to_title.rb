class ChangeJobNoteToTitle < ActiveRecord::Migration[5.1]
  def change
    rename_column :service_ticket_jobs, :note, :title
  end
end
