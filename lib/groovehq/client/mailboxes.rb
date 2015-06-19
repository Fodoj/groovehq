module GrooveHQ
  class Client

    module Mailboxes

      def mailboxes(options = {})
        get("/mailboxes", options)
      end

    end

  end
end
