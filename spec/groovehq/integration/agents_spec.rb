require 'spec_helper'

describe GrooveHQ::Client::Agents, integration: true do

  let(:client) { GrooveHQ::Client.new }
  let(:email) { "fodojyko@gmail.com" }

  describe "#agent" do

    let(:response) { client.agent(email) }

    it "successfully gets agent" do
      expect(response.data).to have_attributes(email: String)
    end

    it "gets the right agent info" do
      expect(response.data).to have_attributes(email: email, first_name: "Testagent")
    end

  end

  describe "#agents" do

    let(:response) { client.agents }

    it "successfully gets agents" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

    it "gets the right agents info" do
      expect(response.first.data).to have_attributes(email: email, first_name: "Testagent")
    end

  end

end
