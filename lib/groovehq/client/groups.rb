module GrooveHQ
  class Client

    module Groups

      def groups(options = {})
        get("/groups", options)
      end

    end

  end
end
