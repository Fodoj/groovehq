require 'spec_helper'

describe GrooveHQ::Client::Customers, integration: true do

  let(:client) { GrooveHQ::Client.new }
  let(:customer_email) { "customer@example.com" }

  describe "#update_customer" do

    it "updates customer info" do
      new_about_text = "Some new about text " + SecureRandom.uuid
      response = client.update_customer(customer_email, about: new_about_text)
      customer = client.customer(customer_email)
      expect(customer.about).to eq new_about_text
      expect(response.rels[:tickets]).not_to be_nil
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
