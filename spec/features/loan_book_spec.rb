require 'rails_helper'

describe 'Log in', type: :feature do
  let(:user) { create(:user) }
  let!(:book) { create(:book) }

  before do
    visit new_user_session_path
    login_as user
  end

  context 'when user is registered' do

    it 'loans book' do
      within '#new_user' do
        click_button 'Log in'
      end
      click_button "Loan"
      expect(page).to have_content('Book Loan was successfully created.')
    end
  end
end