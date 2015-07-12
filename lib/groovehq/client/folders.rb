module GrooveHQ
  class Client

    module Folders

      def folders(options = {})
        get("/folders", options)
      end

    end

  end
end
