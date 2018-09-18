class RemoveNoteFromTag < ActiveRecord::Migration[5.1]
  def change
    remove_column :tags, :note
  end
end
