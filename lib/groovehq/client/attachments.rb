module GrooveHQ
  class Client

    module Attachments

      def attachments(msg_id)
        get("/attachments?message=#{msg_id}")
      end

    end

  end
end
