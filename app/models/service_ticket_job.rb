class ServiceTicketJob < ApplicationRecord
  belongs_to :service_ticket
  belongs_to :user

  has_many :notes, dependent: :destroy
end
