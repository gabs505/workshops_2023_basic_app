class LoanEndReminderJob
  include Sidekiq::Job

  def perform
    BookLoan.upcoming_due_date(Date.today + 1.day).each do |book_loan|
      UserMailer.loan_end_reminder_email(book_loan).deliver_now
    end
  end
end