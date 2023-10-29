class AddCalendarEventIdToBookLoans < ActiveRecord::Migration[7.0]
  def change
    add_column :book_loans, :calendar_event_id, :string
  end
end
