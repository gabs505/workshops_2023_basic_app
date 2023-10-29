class UserCalendarNotifier
  require 'google/apis/calendar_v3'
  require 'google/api_client/client_secrets'

  CALENDAR_ID = 'primary'.freeze

  def initialize(user, book_loan)
    @user = user
    @book_loan = book_loan
  end

  def insert_event
    return unless user.token.present? && user.refresh_token.present?

    event = google_calendar_client.insert_event(CALENDAR_ID, event_data)
    @book_loan.update!(calendar_event_id: event.id)
  end

  def delete_event
    return unless book_loan.calendar_event_id.present? && user.token.present? && user.refresh_token.present?

    google_calendar_client.delete_event(CALENDAR_ID, book_loan.calendar_event_id)
  end

  private

  attr_reader :user, :book_loan

  def google_calendar_client
    client = Google::Apis::CalendarV3::CalendarService.new

    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = 'refresh_token'
    rescue StandardError => e
      Rails.logger.debug e.message
    end

    client
  end

  def event_data
    book = book_loan.book
    {
      summary: "Return book: #{book.title}",
      description: "Upcoming due date for: #{book.title}",
      start: {
        date_time: two_week_from_now.to_datetime.to_s
      },
      end: {
        date_time: (two_week_from_now + 1.hour).to_datetime.to_s
      }
    }
  end

  def two_week_from_now
    @two_week_from_now ||= Time.zone.now + 14.days
  end

  def secrets
    Google::APIClient::ClientSecrets.new({
                                           'web' => {
                                             'access_token' => user.token,
                                             'refresh_token' => user.refresh_token,
                                             'client_id' => A9n.google_client_id,
                                             'client_secret' => A9n.google_client_secret
                                           }
                                         })
  end

end