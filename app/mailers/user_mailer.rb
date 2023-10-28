class UserMailer < ApplicationMailer

  def loan_created_email(book_loan)
    send_email(book_loan, "Upcoming due date")
  end

  def loan_end_reminder_email(book_loan)
    send_email(book_loan, "End of loan")
  end

  def send_email(book_loan, subject)
    @title = book_loan.book.title
    @due_date = book_loan.due_date
    mail({ to: book_loan.user.email, subject: subject })
  end
end