require 'spec_helper'

describe GrooveHQ::Client::Customers, integration: true do

  let(:client) { GrooveHQ::Client.new }
  let(:customer_email) { "customer@example.com" }

  describe "#update_customer" do

    it "updates customer info" do
      customer = client.customer(customer_email)
      new_about_text = "Some new about text"
      response = client.update_customer(customer_email, about: new_about_text)
      expect(response.rels[:tickets].href).to eq "http://api.groovehq.com/v1/tickets?customer=#{customer.id}"
    end

  end

  describe "#customer" do

    let(:response) { client.customer(customer_email) }

    it "successfully gets customer" do
      expect(response.data).to have_attributes(id: String, email: String)
    end

    it "gets the right customer info" do
      expect(response.data).to have_attributes(email: customer_email, name: "Testcustomer")
    end

  end

  describe "#customers" do

    let(:response) { client.customers }

    it "successfully gets customers" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

    it "gets the right customers info" do
      expect(response.any? { |customer| customer.email == customer_email }).to be true
    end

  end

end
