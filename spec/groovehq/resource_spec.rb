require 'spec_helper'

describe GrooveHQ::Resource do

  let(:client) { GrooveHQ::Client.new("phantogram") }

  context "#data" do

    it "returns empty data for invalid input" do
      resource = GrooveHQ::Resource.new(client, "")
      expect(resource.data.to_h).to eql({})
    end

    it "parses data correctly" do
      data = {
        name: "When I am small"
      }
      resource = GrooveHQ::Resource.new(client, data)
      expect(resource.data[:name]).to eql "When I am small"
    end

    it "adds getters for data" do
      data = {
        name: "When I am small"
      }
      resource = GrooveHQ::Resource.new(client, data)
      expect(resource.name).to eql "When I am small"
    end
  end

  context "#rels" do

    it "parses relations correctly" do
      data = {
        links: {
          assignee: {
            href: "https://api.groovehq.com/v1/agents/matt@groovehq.com"
          }
        }
      }
      resource = GrooveHQ::Resource.new(client, data)
      expect(resource.rels[:assignee]).to be_instance_of(GrooveHQ::Relation)
    end

    it "parses self relation correctly" do
      data = {
        href: "https://api.groovehq.com/v1/agents/matt@groovehq.com"
      }
      resource = GrooveHQ::Resource.new(client, data)
      expect(resource.rels[:self]).to be_instance_of(GrooveHQ::Relation)
    end

  end

end
