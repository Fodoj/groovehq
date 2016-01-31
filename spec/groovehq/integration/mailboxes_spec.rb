require 'spec_helper'

describe GrooveHQ::Client::Mailboxes, integration: true do

  let(:client) { GrooveHQ::Client.new }

  describe "#mailboxes" do

    let(:response) { client.mailboxes }

    it "successfully gets mailboxes" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

    it "get the right mailboxes info" do
      expect(response.first.name).to eq "Inbox"
    end

  end

end
