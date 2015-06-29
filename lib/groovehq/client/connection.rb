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

      private

      def request(http_method, path, options)
        response = self.class.send(http_method, path, { query: options })
        data = response.parsed_response
        parse_data(data)
      end

      def parse_data(original_data)
        return unless original_data

        # This hack is added primaraly to deal with API response inconsistencies:
        # https://www.groovehq.com/docs/ticket-counts#listing-ticket-counts (one key per folder)
        # https://www.groovehq.com/docs/tickets#listing-tickets (has two keys: 'tickets' and 'meta')
        # https://www.groovehq.com/docs/tickets#finding-one-ticket (one key: 'ticket')
        # :(
        data = original_data.keys.count <= 2 ? original_data.values.first : original_data

        case data
        when Hash  then Resource.new(self, data)
        when Array then Resource.new(self,
          {
            collection: data.map { |hash| parse_data({resource: hash}) },
            meta: original_data["meta"],
            links: {
              next: {
                href: original_data["meta"]["pagination"]["next_page"]
              },
              prev: {
                href: original_data["meta"]["pagination"]["prev_page"]
              }
            }
          })
        when nil   then nil
        else data
        end
      end

    end

  end
end
