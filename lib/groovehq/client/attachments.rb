module GrooveHQ
  class Client

    module Attachments

      def attachments(message_id)
        get("/attachments", message: message_id)
      end

    end

  end
end
