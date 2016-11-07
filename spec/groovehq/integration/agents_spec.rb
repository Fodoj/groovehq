require 'spec_helper'
include StubHelper

describe GrooveHQ::Client::Agents, integration: true do

  let(:client) { GrooveHQ::Client.new("phantogram") }
  let(:email) { "matt@groovehq.com" }

  describe "#agent" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/agents/#{email}").
        to_return(status: 200, body: load_fixtures(:agent), headers: {})
    end

    let(:response) { client.agent(email) }

    it "successfully gets agent" do
      expect(response.data).to have_attributes(email: String)
    end

    it "gets the right agent info" do
      expect(response.data).to have_attributes(email: email, first_name: "Matthew")
    end
  end

  describe "#agents" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/agents").
        to_return(status: 200, body: load_fixtures(:agents), headers: {})
    end

    let(:response) { client.agents }

    it "successfully gets agents" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

    it "gets the right agents info" do
      expect(response.first.data).to have_attributes(email: email, first_name: "Matthew")
    end
  end
end
