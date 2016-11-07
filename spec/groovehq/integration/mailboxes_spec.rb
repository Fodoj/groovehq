require 'spec_helper'
include StubHelper

describe GrooveHQ::Client::Mailboxes, integration: true do

  let(:client) { GrooveHQ::Client.new }

  describe "#mailboxes" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/mailboxes").
        to_return(status: 200, body: load_fixtures(:mailboxes), headers: {})
    end

    let(:response) { client.mailboxes }

    it "successfully gets mailboxes" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

    it "get the right mailboxes info" do
      expect(response.first.name).to eq "Inbox"
    end
  end
end
