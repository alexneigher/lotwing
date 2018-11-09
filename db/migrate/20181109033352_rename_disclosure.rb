class RenameDisclosure < ActiveRecord::Migration[5.1]
  def change
    rename_column :deals, :discloser, :disclosure
  end
end
