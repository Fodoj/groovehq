module GrooveHQ
  class Client

    module Webhooks

      def create_webhook(options)
        post("/webhooks", options)
      end

      def delete_webhook(id)
        delete("/webhooks/#{id}")
      end

    end

  end
end
