module GrooveHQ
  class Client

    module Customers

      def update_customer(email, options)
        put("/customers/#{email}", options)
      end

      def customer(email)
        get("/customers/#{email}")
      end

      def customers(options = {})
        get("/customers", options)
      end

    end

  end
end
