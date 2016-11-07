require 'spec_helper'
include StubHelper

describe GrooveHQ::Client::Groups, integration: true do

  let(:client) { GrooveHQ::Client.new }

  describe "#groups" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/groups").
        to_return(status: 200, body: load_fixtures(:groups), headers: {})
    end

    let(:response) { client.groups }

    it "successfully gets groups" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end
  end
end
