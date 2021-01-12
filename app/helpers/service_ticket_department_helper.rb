module ServiceTicketDepartmentHelper
  def service_ticket_department_ownership_text(std, user_method, timestamp_method)
    str1 = std.send(user_method)&.full_name.presence || ""
    str2 = std.send(timestamp_method)&.in_time_zone("US/Pacific")&.strftime("%m/%d/%Y %l:%M %p").presence || ""

    return str1 + "<br>"+ str2
  end
end