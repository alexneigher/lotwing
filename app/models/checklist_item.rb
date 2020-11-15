class ChecklistItem < ApplicationRecord
  belongs_to :daily_checklist

  enum item_tier: {red: 'red', yellow: 'yellow'}
end
