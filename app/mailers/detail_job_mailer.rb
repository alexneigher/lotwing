class DetailJobMailer < ActionMailer::Base
  default :from => "Lotwing Admin <admin@lotwing.herokuapp.com>"

  def job_completed(job)
    @job = job
    @sales_rep = @job.sales_rep
    mail( :to => @sales_rep.email, :subject => "Your detail job for stock number #{@job.stock_number} is complete!" )
  end

end