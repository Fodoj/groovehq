require 'spec_helper'

describe GrooveHQ::Client::Messages, integration: true do

  let(:client) { GrooveHQ::Client.new }

  describe "#create_message" do

    it "successfully creates message" do
      body_text = "Some body text"
      response = client.create_message('1', body: body_text)
      expect(response.body).to eq body_text
    end

  end

  describe "#message" do

    let(:response) { client.message('24534728') }

    it "successfully gets message" do
      expect(response.data).to have_attributes(created_at: String)
    end

    it "gets the right message info" do
      expect(response.body).to include("<p>Hi Andrey,</p>\n<p>")
    end

  end

  describe "#messages" do

    let(:response) { client.messages('1') }

    it "successfully gets messages" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

    it "gets the right messages info" do
      expect(response.first.body).to include("<p>Hi Andrey,</p>\n<p>")
    end

  end

end
