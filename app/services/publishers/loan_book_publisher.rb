require 'bunny'

module Publishers
  class LoanBookPublisher
    def initialize(data, loan_status)
      @data = data
      @loan_status = loan_status
    end

    def publish
      Publishers::Application.new(message: @data, routing_key: routing_key,
                                  exchange_name: 'basic_app_topic').perform
    end

    private

    attr_reader :loan_status

    def routing_key
      "basic_app.book_loans.#{loan_status}"
    end
  end
end