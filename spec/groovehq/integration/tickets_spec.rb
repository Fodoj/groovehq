require 'spec_helper'

describe GrooveHQ::Client::Tickets, integration: true do

  let(:client) { GrooveHQ::Client.new }

  describe "#tickets_count" do

    it "successfully gets tickets count" do
      response = client.tickets_count
      expect(response).to be_instance_of GrooveHQ::Resource
    end

  end

  describe "#create_ticket" do

    it "successfully creates ticket" do
      options = {
        body: "Some body text",
        from: "fodojyko@gmail.com",
        to: "customer@example.com"
      }
      response = client.create_ticket(options)
      expect(response.summary).to eq options[:body]
    end

      it "successfully can include customer details in ticket" do
      customer_hash = {
        email: "customer@example.com",
        about: "Your internal reference",
        company_name: "SomeCompany Pty Ltd"
      }

      options = {
        body: "Some body text",
        from: "fodojyko@gmail.com",
        to: customer_hash
      }
      response = client.create_ticket(options)
      customer = response.rels['customer'].get
      expect(customer.company_name).to eq customer_hash[:company_name]
      expect(customer.email).to eq customer_hash[:email]
      expect(customer.about).to eq customer_hash[:about]
    end

  end

  describe "#ticket" do

    let(:response) { client.ticket('9') }

    it "successfully gets ticket" do
      expect(response.data).to have_attributes(created_at: String, number: Fixnum)
    end

    it "gets the right ticket info" do
      expect(response.title).to eq "Hello"
    end

  end

  describe "#tickets" do

    it "successfully gets tickets" do
      response = client.tickets
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

  end

  describe "#ticket_state" do

    it "successfully gets ticket state" do
      response = client.ticket_state('8')
      expect(response).to be_instance_of String
    end

  end

  describe "#update_ticket_state" do

    it "successfully updates ticket state" do
      client.update_ticket_state('8', 'pending')
      client.update_ticket_state('8', 'opened')
      current_state = client.ticket_state('8')
      expect(current_state).to eq 'opened'
    end

  end

  describe "#ticket_assignee" do

    context "when ticket has an assignee" do
      it "successfully gets ticket assignee" do
        response = client.ticket_assignee('8')
        expect(response.email).to eq "fodojyko@gmail.com"
      end
    end

    context "when ticket has no assignee" do
      it "returns nil" do
        response = client.ticket_assignee('2')
        expect(response).to be_nil
      end
    end

  end

  describe "#update_ticket_assignee" do

    it "successfully updates ticket assignee" do
      client.update_ticket_assignee('7', "fodojyko@gmail.com")
      current_assignee = client.ticket_assignee('7')
      expect(current_assignee.email).to eq "fodojyko@gmail.com"
    end

  end

  describe "#update_ticket_priority" do

    it "successfully updates ticket priority" do
      client.update_ticket_priority('8', 'high')
      current_priority = client.ticket('8').priority
      expect(current_priority).to eq "high"
    end

  end

  describe "#update_ticket_assigned_group" do

    it "successfully updates ticket assigned group" do
      client.update_ticket_assigned_group('8', 'test_group')
      current_assigned_group = client.ticket('8').assigned_group
      expect(current_assigned_group).to eq 'test_group'
    end

  end

end
