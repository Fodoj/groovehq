module GrooveHQ
  class Client

    module Tickets

      def tickets(options = {})
        response = self.class.get("/tickets", { query: options })

        response.parsed_response["tickets"]
      end

    end

  end
end
