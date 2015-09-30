module GrooveHQ
  class Client

    module Attachments

      def attachments(options = {})
        get("/attachments", options)
      end

    end

  end
end
