require 'rails_helper'

RSpec.describe LoanEndReminderJob do
  let!(:book_loan) { create(:book_loan, due_date: Date.today + 1.day) }
  let(:delivery) { double }

  it "sends an email" do
    expect { described_class.perform_inline }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "invokes loan_end_reminder_email" do
    expect(delivery).to receive(:deliver_now).with(no_args)

    expect(UserMailer).to receive(:loan_end_reminder_email)
                            .with(book_loan)
                            .and_return(delivery)
    described_class.perform_inline
  end
end