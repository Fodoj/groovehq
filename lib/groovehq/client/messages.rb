module GrooveHQ
  class Client

    module Messages

      def create_message(ticket_number, options)
        post("/tickets/#{ticket_number}/messages", options)
      end

      def message(message_id)
        get("/messages/#{message_id}")
      end

      def messages(ticket_number, options = {})
        get("/tickets/#{ticket_number}/messages", options)
      end

    end

  end
end
