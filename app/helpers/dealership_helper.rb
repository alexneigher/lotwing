module DealershipHelper

  def current_dealership
    @current_dealership ||= current_user.dealership
  end

end