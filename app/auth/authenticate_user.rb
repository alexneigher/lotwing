# app/auth/authenticate_user.rb
class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :email, :password, :user

  #this is where parameters are taken when the command is called
  def initialize(email, password)
    @email = email
    @password = password
  end
  
  #this is where the result gets returned
  def call
    JsonWebToken.encode(user_id: user.id) if user
  end


  def user
    return @user if @user.present?
    
    @user = User.find_by_email(email)
    return @user if @user && @user.valid_password?(password) && @user.active?

    errors.add :user_authentication, 'Invalid credentials'
    nil
  end
end