class ServiceTicketMailer < ActionMailer::Base
  default :from => "Lotwing Admin <admin@lotwing.herokuapp.com>"

  def self.notify_about_service_ticket_created(service_ticket)
    @service_ticket = service_ticket

    recipients = @service_ticket.dealership.new_service_ticket_notification_addresses.split(',').uniq
    
    recipients.each do |email|
      ServiceTicketMailer.new_service_ticket_created(service_ticket, email.strip).deliver
    end
  end

  def new_service_ticket_created(service_ticket, email)
    @service_ticket = service_ticket
    @email = email

    mail( to: @email, subject: "Vehicle #{@service_ticket.stock_number} has a new service ticket." )
  end

end