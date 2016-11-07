require 'spec_helper'

describe GrooveHQ::Client::Attachments, integration: true do

  let(:client) { GrooveHQ::Client.new }

  describe "#attachments" do

    let(:response) { client.attachments(message_id) }

    context "when message has attachments" do
      let(:message_id) { '4898749908' } # message with attachments

      it "successfully gets attachments" do
        expect(response).to be_instance_of GrooveHQ::ResourceCollection
      end
    end

    context "when message has no attachments" do
      let(:message_id) { '25662182"' } # message without attachments

      it "returns nil" do
        expect(response).to be_nil
      end
    end

  end

end
