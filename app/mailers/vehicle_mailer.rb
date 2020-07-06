class VehicleMailer < ActionMailer::Base
  default :from => "Lotwing Admin <admin@lotwing.herokuapp.com>"

  def self.duplicate_stock_numbers(dealership, grouped_stock_numbers)
    recipients = dealership
                  .users
                  .joins(:email_preference)
                  .where(email_preferences: {duplicate_stock_number_email: true})
                  .pluck(:email)
                  .uniq

    recipients.each do |email|
      VehicleMailer.notify_about_duplicate_stock_numbers(grouped_stock_numbers, email.strip).deliver
    end

  end

  def notify_about_duplicate_stock_numbers(grouped_stock_numbers, email)
    @grouped_stock_numbers = grouped_stock_numbers

    mail( :to => email, :subject => "Duplicate Stock Numbers Found!" )
  end

end