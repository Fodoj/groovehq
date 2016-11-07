require 'spec_helper'
include StubHelper

describe GrooveHQ::Client::Customers, integration: true do

  let(:client) { GrooveHQ::Client.new("phantogram") }
  let(:customer_email) { "customer@example.com" }

  describe "#update_customer" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/customers/#{customer_email}").
        to_return(status: 200, body: load_fixtures(:customer), headers: {})
      stub_request(:put, "https://api.groovehq.com/v1/customers/#{customer_email}").
        with(body: {about: new_about_text}).
        to_return(status: 200, body: load_fixtures(:customer_updated), headers: {})
    end

    let(:customer) { client.customer(customer_email) }
    let(:new_about_text) { "Some new about text" }
    let(:response) { client.update_customer(customer_email, about: new_about_text) }

    it "updates customer info" do
      expect(response.data.about).to eq new_about_text
      expect(response.rels[:tickets].href).to eq "https://api.groovehq.com/v1/tickets?customer=#{customer.email}"
    end
  end

  describe "#customer" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/customers/#{customer_email}").
        to_return(status: 200, body: load_fixtures(:customer), headers: {})
    end

    let(:response) { client.customer(customer_email) }

    it "successfully gets customer" do
      expect(response.data).to have_attributes(email: String)
    end

    it "gets the right customer info" do
      expect(response.data).to have_attributes(email: customer_email, name: "John Smith")
    end
  end

  describe "#customers" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/customers").
        to_return(status: 200, body: load_fixtures(:customers), headers: {})
    end

    let(:response) { client.customers }

    it "successfully gets customers" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

    it "gets the right customers info" do
      expect(response.any? { |customer| customer.email == customer_email }).to be true
    end

  end
end
