class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :dealership, optional: true

  has_many :events
  has_one :email_preference

  enum permission_level: [:sales_rep, :sales_manager, :admin, :service_user, :detail_job_user, :service_manager]
  enum status: [:active, :deactivated]

  after_create :set_default_email_preference

  accepts_nested_attributes_for :email_preference, update_only: true

  def active_for_authentication?
    super && !deactivated?
  end

  private
    def set_default_email_preference
      self.create_email_preference
    end
end
