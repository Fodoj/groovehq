require 'spec_helper'
include StubHelper

describe GrooveHQ::Client::Messages, integration: true do

  let(:client) { GrooveHQ::Client.new }
  let(:body_text) { "Some body text" }
  let(:ticket_number) { '8' }

  describe "#create_message" do
    before do
      stub_request(:post, "https://api.groovehq.com/v1/tickets/#{ticket_number}/messages").
        to_return(status: 200, body: load_fixtures(:message), headers: {})
    end

    it "successfully creates message" do
      response = client.create_message('8', body: body_text)
      expect(response.body).to eq body_text
    end
  end

  describe "#message" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/messages/#{message_id}").
        to_return(status: 200, body: load_fixtures(:message), headers: {})
    end
    let(:message_id) { '25662284' }
    let(:response) { client.message(message_id) }

    it "successfully gets message" do
      expect(response.data).to have_attributes(created_at: String)
    end

    it "gets the right message info" do
      expect(response.body).to include(body_text)
    end
  end

  describe "#messages" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/tickets/#{ticket_number}/messages").
        to_return(status: 200, body: load_fixtures(:messages), headers: {})
    end
    let(:response) { client.messages(ticket_number) }

    it "successfully gets messages" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

    it "gets the right messages info" do
      expect(response.first.body).to include(body_text)
    end
  end
end
