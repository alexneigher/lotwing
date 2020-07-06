class EventMailer < ActionMailer::Base
  default :from => "Lotwing Admin <admin@lotwing.herokuapp.com>"

  def self.notify_about_note_created(event)
    @event = event

    recipients = @event
                  .user
                  .dealership
                  .users
                  .joins(:email_preference)
                  .where(email_preferences: {note_email: true})
                  .pluck(:email)
                  .uniq

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