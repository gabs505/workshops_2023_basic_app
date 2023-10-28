require 'bunny'

module Publishers
  class LoanBookPublisher
    def initialize(data)
      @data = data
    end

    def publish
      Publishers::Application.new(message: @data, routing_key: 'basic_app.book_loans',
                                  exchange_name: 'basic_app').perform
    end
  end
end