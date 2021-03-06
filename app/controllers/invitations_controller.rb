class InvitationsController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'static'

  def view_invitation
    @user = User.find_by_reset_password_token(params[:reset_password_token])
    redirect_to root_path and return unless @user
  end

  def accept_invitation
    @user = User.find_by_reset_password_token(params[:reset_password_token])
    
    @user.update(password: params[:user][:password], password_confirmation: params[:user][:password])
    
    sign_in(@user)

    redirect_to root_path
  end

end