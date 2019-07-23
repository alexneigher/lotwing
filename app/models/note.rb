class Note < ApplicationRecord
  belongs_to :user
  belongs_to :service_ticket_job
end
