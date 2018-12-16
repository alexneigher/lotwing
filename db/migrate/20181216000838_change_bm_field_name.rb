class ChangeBmFieldName < ActiveRecord::Migration[5.1]
  def change
    rename_column :deals, :program_description, :bulletin_number

    remove_column :deals, :missing_stips_1
    remove_column :deals, :missing_stips_2
  end
end
