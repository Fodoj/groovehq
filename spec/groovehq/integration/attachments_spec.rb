require 'spec_helper'
include StubHelper

describe GrooveHQ::Client::Attachments, integration: true do

  let(:client) { GrooveHQ::Client.new("phantogram") }

  describe "#attachments" do

    context "when message has attachments" do
      before do
        stub_request(:get, "https://api.groovehq.com/v1/attachments").
          to_return(status: 200, body: load_fixtures(:attachments), headers: {})
      end
      let(:response) { client.attachments(message_id) }
      let(:message_id) { '9789054751' } # message with attachments

      it "successfully gets attachments" do
        expect(response).to be_instance_of GrooveHQ::ResourceCollection
      end
    end

    context "when message has no attachments" do
      before do
        stub_request(:get, "https://api.groovehq.com/v1/attachments").
          to_return(status: 200, body: "", headers: {})
      end
      let(:response) { client.attachments(message_id) }
      let(:message_id) { '25662182' } # message without attachments

      it "returns nil" do
        expect(response).to be_nil
      end
    end
  end
end
