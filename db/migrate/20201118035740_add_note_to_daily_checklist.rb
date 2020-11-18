class AddNoteToDailyChecklist < ActiveRecord::Migration[5.1]
  def change
    add_reference :notes, :daily_checklist
  end
end
