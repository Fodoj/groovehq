require 'spec_helper'
include StubHelper

describe GrooveHQ::Client::Tickets, integration: true do

  let(:client) { GrooveHQ::Client.new }
  let(:ticket_number) { '11' }

  describe "#tickets_count" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/tickets/count").
        to_return(status: 200, body: load_fixtures(:tickets_count), headers: {})
    end

    it "successfully gets tickets count" do
      response = client.tickets_count
      expect(response).to be_instance_of GrooveHQ::Resource
    end
  end

  describe "#create_ticket" do
    before do
      stub_request(:post, "https://api.groovehq.com/v1/tickets").
        with(body: options).
        to_return(status: 201, body: load_fixtures(:ticket), headers: {})
      stub_request(:get, "https://api.groovehq.com/v1/customers/customer@somewhere.com").
        to_return(status: 200, body: load_fixtures(:customer), headers: {})
    end

    let(:customer_hash) do
      {
        email: "customer@example.com",
        about: "Your internal reference",
        company_name: "SomeCompany Pty Ltd"
      }
    end

    let(:options) do
      {
        body: "This is the first 100 characters of the first message...",
        from: "matt@groovehq.com",
        to: customer_hash
      }
    end

    it "successfully creates ticket" do
      response = client.create_ticket(options)
      expect(response.summary).to eq options[:body]
    end

    it "successfully can include customer details in ticket" do
      response = client.create_ticket(options)
      customer = response.rels['customer'].get
      expect(customer.company_name).to eq customer_hash[:company_name]
      expect(customer.email).to eq customer_hash[:email]
      expect(customer.about).to eq customer_hash[:about]
    end
  end

  describe "#ticket" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/tickets/#{ticket_number}").
        to_return(status: 200, body: load_fixtures(:ticket), headers: {})
    end
    let(:response) { client.ticket(ticket_number) }

    it "successfully gets ticket" do
      expect(response.data).to have_attributes(created_at: String, number: Fixnum)
    end

    it "gets the right ticket info" do
      expect(response.title).to eq "Hello"
    end
  end

  describe "#tickets" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/tickets").
        to_return(status: 200, body: load_fixtures(:tickets), headers: {})
    end

    it "successfully gets tickets" do
      response = client.tickets
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end
  end

  describe "#ticket_state" do
    before do
      stub_request(:get, "https://api.groovehq.com/v1/tickets/#{ticket_number}/state").
        to_return(status: 200, body: state, headers: {})
    end
    
    let(:state) { { state: "unread" }.to_json }

    it "successfully gets ticket state" do
      response = client.ticket_state(ticket_number)
      expect(response).to be_instance_of String
    end
  end

  describe "#update_ticket_state" do
    before do
      stub_request(:put, "https://api.groovehq.com/v1/tickets/#{ticket_number}/state").
        to_return(status: 204, body: "", headers: {})
      stub_request(:get, "https://api.groovehq.com/v1/tickets/#{ticket_number}/state").
        to_return(status: 200, body: state, headers: {})
    end

    let(:state) { { state: "opened" }.to_json }

    it "successfully updates ticket state" do
      client.update_ticket_state(ticket_number, 'opened')
      current_state = client.ticket_state(ticket_number)
      expect(current_state).to eq 'opened'
    end
  end

  describe "#ticket_assignee" do

    context "when ticket has an assignee" do
      before do
        stub_request(:get, "https://api.groovehq.com/v1/tickets/#{ticket_number}/assignee").
          to_return(status: 200, body: load_fixtures(:assignee), headers: {})
      end
      it "successfully gets ticket assignee" do
        response = client.ticket_assignee(ticket_number)
        expect(response.email).to eq "matt@groovehq.com"
      end
    end

    context "when ticket has no assignee" do
      before do
        stub_request(:get, "https://api.groovehq.com/v1/tickets/#{ticket_number}/assignee").
          to_return(status: 200, body: "", headers: {})
      end
      it "returns nil" do
        response = client.ticket_assignee(ticket_number)
        expect(response).to be_nil
      end
    end
  end

  describe "#update_ticket_assignee" do
    before do
      stub_request(:put, "https://api.groovehq.com/v1/tickets/#{ticket_number}/assignee").
        to_return(status: 204, body: "", headers: {})
      stub_request(:get, "https://api.groovehq.com/v1/tickets/#{ticket_number}/assignee").
        to_return(status: 200, body: load_fixtures(:assignee_updated), headers: {})
    end

    it "successfully updates ticket assignee" do
      client.update_ticket_assignee(ticket_number, "fodojko@gmail.com")
      current_assignee = client.ticket_assignee(ticket_number)
      expect(current_assignee.email).to eq "fodojko@gmail.com"
    end
  end

  describe "#update_ticket_priority" do
    before do
      stub_request(:put, "https://api.groovehq.com/v1/tickets/#{ticket_number}/priority").
        to_return(status: 204, body: "", headers: {})
      stub_request(:get, "https://api.groovehq.com/v1/tickets/#{ticket_number}").
        to_return(status: 200, body: load_fixtures(:ticket), headers: {})
    end

    it "successfully updates ticket priority" do
      client.update_ticket_priority(ticket_number, 'high')
      current_priority = client.ticket(ticket_number).priority
      expect(current_priority).to eq "high"
    end
  end

  describe "#update_ticket_assigned_group" do
    before do
      stub_request(:put, "https://api.groovehq.com/v1/tickets/#{ticket_number}/assigned_group").
        to_return(status: 204, body: "", headers: {})
      stub_request(:get, "https://api.groovehq.com/v1/tickets/#{ticket_number}").
        to_return(status: 200, body: load_fixtures(:ticket), headers: {})
    end

    it "successfully updates ticket assigned group" do
      client.update_ticket_assigned_group(ticket_number, 'test_group')
      current_assigned_group = client.ticket(ticket_number).assigned_group
      expect(current_assigned_group).to eq 'test_group'
    end
  end
end
