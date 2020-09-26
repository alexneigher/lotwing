class AddSpecialInstructionsToDetailJob < ActiveRecord::Migration[5.1]
  def change
    add_column :detail_jobs, :special_instructions, :string
  end
end
