class Note < ApplicationRecord
  belongs_to :user
  belongs_to :service_ticket_job, optional: true

  belongs_to :daily_checklist, optional: true
end
