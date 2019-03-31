class EventMailer < ActionMailer::Base
  default :from => 'admin@lotwing.herokuapp.com'

  def notify_about_note_created(event_id)
    @event = Event.find(event_id)

    recipients = @event.user.dealership.new_note_notification_addresses.split(',').uniq
    
    recipients.each do |email|
      mail( to: email, subject: "#{@event.user.full_name} has added a new note." ).deliver
    end
  end

end