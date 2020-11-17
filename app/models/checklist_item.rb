class ChecklistItem < ApplicationRecord
  belongs_to :daily_checklist

  has_one :completed_by_user, class_name: 'User', foreign_key: :id, primary_key: :completed_by_user_id

  enum item_tier: {sales_manager_red: 'sales_manager_red', sales_manager_yellow: 'sales_manager_yellow', service_manager_yellow: 'service_manager_yellow'}
end
