module GrooveHQ

  class Resource
    attr_reader :rels, :data

    def initialize(client, data)
      @client = client
      @data = data
      @rels = parse_rels
    end

    def parse_rels
      @data["links"].each_with_object({}) do |(relation, value), result|
        result[relation] = Relation.new(@client, value["href"])
      end
    end
  end

end
