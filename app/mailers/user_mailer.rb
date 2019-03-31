class UserMailer < ActionMailer::Base
  default :from => 'admin@lotwing.herokuapp.com'
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email, :subject => "You've been invited to join #{@user.dealership.name} on Lotwing!" )
  end

end