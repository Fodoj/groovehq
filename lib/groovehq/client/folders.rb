module GrooveHQ
  class Client

    module Folders

      # Doesn't work, waiting for GrooveHQ team to clarify
      def folders(options = {})
        get("/folders", options)
      end

    end

  end
end
