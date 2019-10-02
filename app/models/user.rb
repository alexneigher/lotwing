class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :dealership, optional: true

  has_many :events

  enum permission_level: [:sales_rep, :sales_manager, :admin, :service_user]
  enum status: [:active, :deactivated]

  def active_for_authentication?
    super && !deactivated?
  end
end
