module GrooveHQ

  class Resource
    attr_reader :rels, :data

    def initialize(client, data)
      data = {} unless data.is_a?(Hash)

      @client = client
      @data   = data.with_indifferent_access

      links        = @data.delete(:links) { Hash.new }
      links[:self] = @data.delete(:href) if @data.has_key?(:href)

      @rels = parse_links(links).with_indifferent_access
    end

    def parse_links(links)
      (links || {}).each_with_object({}) do |(relation, value), result|
        result[relation] = Relation.new(@client, value["href"])
      end
    end
  end

end
