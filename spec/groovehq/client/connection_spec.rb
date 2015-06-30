require 'spec_helper'

describe GrooveHQ::Client::Connection do

  let(:client) { GrooveHQ::Client.new("phantogram") }

  it "returns nil for empty response" do
    stub_request(:get, "https://api.groovehq.com/v1/tickets").to_return(body: "")
    expect(client.get("/tickets")).to eql(nil)
  end

  context "nested hash as response with single root key" do

    let(:response) do
      {
        ticket: {
          number: 1,
          summary: "This is the first 100 characters of the first message...",
          links: {
            assignee: {
              href: "https://api.groovehq.com/v1/agents/matt@groovehq.com"
            }
          }
        }
      }.to_json
    end

    before(:each) do
      stub_request(:get, "https://api.groovehq.com/v1/tickets/1").to_return(body: response)
    end

    it "returns resource for single root key" do
      expect(client.get("/tickets/1")).to be_instance_of(GrooveHQ::Resource)
    end

    it "returns resource with correct relations" do
      expect(client.get("/tickets/1").rels[:assignee].href).to eql("https://api.groovehq.com/v1/agents/matt@groovehq.com")
    end

  end

  context "single key-value pair in response" do

    let(:response) do
      { state: "open" }.to_json
    end

    before(:each) do
      stub_request(:get, "https://api.groovehq.com/v1/tickets/1/state").to_return(body: response)
    end

    it "returns response as it is" do
      expect(client.get("/tickets/1/state")).to eql "open"
    end

  end

  context "multiple root key-value pairs in response" do

    let(:response) do
      {
        "728525" => 1,
        "987452" => 0,
        "842376" => 0
      }.to_json
    end

    before(:each) do
      stub_request(:get, "https://api.groovehq.com/v1/tickets/count").to_return(body: response)
    end

    it "returns response as it is" do
      expect(client.get("/tickets/count").data.keys.count).to eql 3
    end

  end

  context "array of hashes in response" do

    let(:response) do
      {
        tickets: [
          { number: 1 },
          { number: 2 },
          { number: 3 }
        ],
        meta: {
          pagination: {
            next_page: "https://api.groovehq.com/v1/tickets/?page=2",
            prev_page: nil
          }
        }
      }.to_json
    end

    before(:each) do
      stub_request(:get, "https://api.groovehq.com/v1/tickets").to_return(body: response)
    end

    it "builds array of resources from response" do
      expect(client.get("/tickets").data[:collection].count).to eql 3
    end

    it "returns relations for pagination" do
      expect(client.get("/tickets").rels[:next]).to be_instance_of(GrooveHQ::Relation)
    end

  end

end
