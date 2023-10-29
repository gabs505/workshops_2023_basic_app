require 'rails_helper'

RSpec.describe LoanCreatedJob do
  let!(:book_loan) { create(:book_loan) }
  let(:delivery) { double }

  it "sends an email" do
    expect { described_class.perform_inline(book_loan.id) }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "invokes loan_created_email" do
    expect(delivery).to receive(:deliver_now).with(no_args)

    expect(UserMailer).to receive(:loan_created_email)
                            .with(book_loan)
                            .and_return(delivery)
    described_class.perform_inline(book_loan.id)
  end
end