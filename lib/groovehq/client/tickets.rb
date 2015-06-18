module GrooveHQ
  class Client

    module Tickets

      def ticket(ticket_number, options = {})
        get("/tickets/#{ticket_number}", { query: options })
      end

    end

  end
end
