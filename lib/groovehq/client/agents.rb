module GrooveHQ
  class Client

    module Agents

      def agent(email)
        get("/agents/#{email}")
      end

      def agents(options = {})
        get("/agents", options)
      end

    end

  end
end
