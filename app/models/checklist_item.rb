class ChecklistItem < ApplicationRecord
  belongs_to :daily_checklist

  has_one :completed_by_user, class_name: 'User', foreign_key: :id, primary_key: :completed_by_user_id

  enum item_tier: {sales_manager_red: 'sales_manager_red', sales_manager_yellow: 'sales_manager_yellow', service_manager_yellow: 'service_manager_yellow'}


  # used for the custom JSON array of text and repeat interval columns
  # sales_managers_custom_reminder_checklist_items & service_managers_custom_reminder_checklist_items
  def self.should_repeat_today?(item)
    return true unless item.try(:[], "repeat_every")&.present?
    return true unless item.try(:[], "anchor_date")&.present?

    # ignore this item if no text is present
    return false unless item.try(:[], "text")&.present?

    anchor_date = item["anchor_date"].to_date
    date_today = Time.current.in_time_zone("US/Pacific").to_date
    days_since_anchor_date = (date_today - anchor_date).to_i

    # do a mod of the number of days since the anchor date, and if that == 0, then do this today,
    # since today is a repeat day
    days_since_anchor_date % item["repeat_every"].to_i == 0
  end
end
