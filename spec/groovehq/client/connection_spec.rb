require 'spec_helper'

describe GrooveHQ::Client::Connection do

  let(:client) { GrooveHQ::Client.new("phantogram") }
  let(:api_groovehq_url) { "https://api.groovehq.com/v1" }

  before(:each) do
    stub_request(:get, "#{api_groovehq_url}#{resource_path}").to_return(body: response)
  end

  subject { client.get(resource_path) }

  context "empty response" do

    let(:resource_path) { "/tickets" }
    let(:response) { '' }

    it "returns nil" do
      expect(subject).to eql(nil)
    end

  end

  context "nested hash as response with single root key" do

    let(:resource_path) { "/tickets/1" }
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

    it "returns resource for single root key" do
      expect(subject).to be_instance_of(GrooveHQ::Resource)
    end

    it "returns resource with correct relations" do
      expect(subject.rels[:assignee].href).to eql("https://api.groovehq.com/v1/agents/matt@groovehq.com")
    end

  end

  context "single key-value pair in response" do

    let(:resource_path) { "/tickets/1/state" }
    let(:response) do
      { state: "open" }.to_json
    end

    it "returns response as it is" do
      expect(subject).to eql "open"
    end

  end

  context "multiple root key-value pairs in response" do

    let(:resource_path) { "/tickets/count" }
    let(:response) do
      {
        "728525" => 1,
        "987452" => 0,
        "842376" => 0
      }.to_json
    end

    it "returns response as it is" do
      expect(subject.data.to_h.keys.count).to eql 3
    end

  end

  context "array of hashes in response" do

    let(:resource_path) { "/tickets" }
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

    it "builds array of resources from response" do
      expect(subject.data[:collection].count).to eql 3
    end

    it "returns relations for pagination" do
      expect(subject.rels[:next]).to be_instance_of(GrooveHQ::Relation)
    end

    context "with request options" do
      subject { client.get(resource_path, per_page: 20) }

      it "retains options" do
        stub_request(:get, "#{api_groovehq_url}#{resource_path}?per_page=20").to_return(body: response)
        expect(subject.options).to eq({})
      end

    end

  end

end
