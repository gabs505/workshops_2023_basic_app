class BookLoan < ApplicationRecord
  belongs_to :book
  belongs_to :user

  enum status: { checked_out: 'checked_out', cancelled: 'cancelled', returned: 'returned' }

  scope :ongoing_by_book, ->(book) { checked_out.where(book:) }
  scope :upcoming_due_date, -> (date) { checked_out.where(due_date: date.beginning_of_day..date.end_of_day) }

  validate :loan_not_available, on: :create

  def loan_not_available
    errors.add(:book, 'loan is not available for you') unless book.loan_available_for?(user)
  end

  def by_user?(user)
    self.user == user
  end
end
