require 'spec_helper'

describe GrooveHQ::Resource do

  let(:client) { GrooveHQ::Client.new("phantogram") }

  context "#data" do

    it "returns empty data for invalid input" do
      resource = GrooveHQ::ResourceCollection.new(self, "")
      expect(resource.count).to eql(0)
    end

    it "parses data correctly" do
      data = {
        tickets: [ { name: "When I am small" } ]
      }
      resource = GrooveHQ::ResourceCollection.new(self, data)
      expect(resource.first.name).to eql "When I am small"
    end

  end

  context "#rels" do

    it "parses relations correctly" do
      data = {
        tickets: [],
        meta: {
          pagination: {
            current_page: 1,
            total_pages: 23,
            total_count: 23,
            next_page: "http://api.groovehq.dev/v1/tickets?page=2"
          }
        }
      }
      resource = GrooveHQ::ResourceCollection.new(self, data)
      expect(resource.rels[:next]).to be_instance_of(GrooveHQ::Relation)
    end

  end

end
