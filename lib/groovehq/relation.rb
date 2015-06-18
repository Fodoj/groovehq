module GrooveHQ

  class Relation < Struct.new(:client, :href)

    def get(options = {})
      client.get href, options
    end

  end

end
