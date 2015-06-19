module GrooveHQ

  class Client

    module Connection

      def get(path, options = {})
        request :get, path, options
      end

      def post(path, options = {})
        request :post, path, options
      end

      def put(path, options = {})
        request :put, path, options
      end

      def delete(path, options = {})
        request :delete, path, options
      end

      def request(method, path, options)
        response = self.class.send(method, path, { query: options })
        data = response.parsed_response
        parse_data(data)
      end

      def parse_data(data)
        return unless data
        data = data.values.first
        case data
        when Hash  then Resource.new(self, data)
        when Array then data.map { |hash| parse_data({resource: hash}) }
        when nil   then nil
        else data
        end
      end

    end

  end
end
