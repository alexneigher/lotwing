class DailyChecklist < ApplicationRecord
  belongs_to :dealership
  has_many :checklist_items, dependent: :destroy

  has_many :uncompleted_red_level_notifications, -> { where(item_tier: "red", completed_at: nil)} , class_name: 'ChecklistItem'
  has_many :uncompleted_yellow_level_notifications, -> { where(item_tier: "yellow", completed_at: nil)}, class_name: 'ChecklistItem'
end
