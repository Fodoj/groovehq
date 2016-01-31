module GrooveHQ

  class ResourceCollection < Resource
    include Enumerable

    def initialize(client, data)
      data = {} unless data.is_a?(Hash)
      data = data.with_indifferent_access

      @client = client

      meta_data = data.delete(:meta) { Hash.new }

      collection = Array(data.values.first).map do |item|
        Resource.new(client, item)
      end

      links = {}

      if meta_data.has_key?("pagination")
        links = {
          next: {
            "href" => meta_data["pagination"]["next_page"]
          },
          prev: {
            "href" => meta_data["pagination"]["prev_page"]
          }
        }.with_indifferent_access
      end

      @data = OpenStruct.new(meta: meta_data, collection: collection)
      @rels = parse_links(links).with_indifferent_access
    end

    def each(&block)
      collection.each { |item| yield item }
    end

  end

end
