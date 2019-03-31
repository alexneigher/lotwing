class EventMailer < ActionMailer::Base
  default :from => 'admin@lotwing.herokuapp.com'

  def self.notify_about_note_created(event)
    @event = event

    recipients = @event.user.dealership.new_note_notification_addresses.split(',').uniq
    
    recipients.each do |email|
      EventMailer.new_note_created(event, email.strip).deliver
    end
  end

  def new_note_created(event, email)
    @event = event
    @email = email

    mail( to: @email, subject: "#{@event.user.full_name} has added a new note." )
  end

end