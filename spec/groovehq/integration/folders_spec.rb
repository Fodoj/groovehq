require 'spec_helper'
include StubHelper

describe GrooveHQ::Client::Folders, integration: true do

  let(:client) { GrooveHQ::Client.new }

  describe "#folders" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/folders").
        to_return(status: 200, body: load_fixtures(:folders), headers: {})
    end

    let(:response) { client.folders }

    it "successfully gets folders" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end
  end
end
