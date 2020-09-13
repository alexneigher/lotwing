class NoteMailer < ActionMailer::Base
  default :from => "Lotwing Admin <admin@lotwing.herokuapp.com>"

  def self.new_service_ticket_note(user_id_info, note_id)
    @note = Note.find(note_id)

    #try to notify the entire department
    if user_id_info.in?(ServiceTicketDepartment::ALL_DEPARTMENTS)
      department_email = user_id_info + "_email"

      recipients = @note
                    .service_ticket_job
                    .service_ticket
                    .dealership
                    .users
                    .active
                    .joins(:email_preference)
                    .where(email_preferences: {department_email => true})
                    .pluck(:email)
                    .uniq

      recipients.each do |email|
        NoteMailer.new_note_created(@note, email).deliver
      end
    elsif user = User.find_by(id: user_id_info)
      NoteMailer.new_note_created(@note, user.email).deliver
    else
      raise "Unknown Recipients #{user_id_info} for note #{note.id}"
    end

  end

  def new_note_created(note, email)
    @note = note
    @email = email

    mail( to: @email, subject: "New Service Ticket Job Note")
  end

end
