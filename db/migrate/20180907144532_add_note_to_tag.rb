class AddNoteToTag < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :note, :text
  end
end
