module GrooveHQ

  class ResourceCollection < Resource
    include Enumerable

    attr_reader :options

    def initialize(client, data, options = {})
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
            href: meta_data["pagination"]["next_page"]
          },
          prev: {
            href: meta_data["pagination"]["prev_page"]
          }
        }
      end

      @data = OpenStruct.new(meta: meta_data, collection: collection)
      @rels = parse_links(links)
      @options = options.with_indifferent_access
    end

    def each
      return enum_for(:each) unless block_given?

      collection.each { |item| yield item }

      rel = @rels[:next] or return self
      coll = rel.get(@options.except(:page))
      coll.each(&Proc.new)

      @data = OpenStruct.new(meta: coll.meta, collection: collection + coll.collection)
      @rels = coll.rels
    end

  end

end
