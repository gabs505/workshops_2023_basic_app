FactoryBot.define do
  factory :book_loan do
    due_date { Faker::Date.between(from: Time.zone.today, to: Time.zone.today + 2.weeks) }
    status { :checked_out }

    book factory: %i[book]
    user factory: %i[user]
  end
end