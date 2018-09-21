class AddTaggedAtToShape < ActiveRecord::Migration[5.1]
  def change
    add_column :shapes, :most_recently_tagged_at, :datetime
  end
end
