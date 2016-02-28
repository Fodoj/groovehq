require 'spec_helper'

describe GrooveHQ::Resource do

  let(:client) { GrooveHQ::Client.new("phantogram") }

  context "#data" do

    it "returns empty data for invalid input" do
      resource = GrooveHQ::ResourceCollection.new(client, "")
      expect(resource.count).to eql(0)
    end

    it "parses data correctly" do
      data = {
        tickets: [ { name: "When I am small" } ]
      }
      resource = GrooveHQ::ResourceCollection.new(client, data)
      expect(resource.first.name).to eql "When I am small"
    end

  end

  context "#rels" do

    it "parses relations correctly" do
      data = {
        tickets: [],
        meta: {
          pagination: {
            current_page: 1,
            total_pages: 23,
            total_count: 23,
            next_page: "http://api.groovehq.dev/v1/tickets?page=2"
          }
        }
      }.stringify_keys

      resource = GrooveHQ::ResourceCollection.new(client, data)
      expect(resource.rels[:next]).to be_instance_of(GrooveHQ::Relation)
      expect(resource.rels[:next].href).to eq("http://api.groovehq.dev/v1/tickets?page=2")
      expect(resource.rels[:prev]).to be_nil
    end

  end

  context "#each" do

    it "returns an enumerator when block omitted" do
      data = {
        tickets: [ { name: "When I am small" } ]
      }

      resource = GrooveHQ::ResourceCollection.new(client, data)
      expect(resource.each).to be_instance_of(Enumerator)
      expect(resource.first.name).to eql "When I am small"
    end

    context "paginated requests" do

      before do
        page_1 = {
          tickets: [{ title: "Ticket 1" }],
          meta: {
            pagination: {
              next_page: "http://api.groovehq.dev/v1/tickets?page=2"
            }
          }
        }.stringify_keys

        page_2 = {
          tickets: [{ title: "Ticket 2"}],
          meta: {
            pagination: {
              prev_page: "http://api.groovehq.dev/v1/tickets?page=1",
              next_page: "http://api.groovehq.dev/v1/tickets?page=3"
            }
          }
        }.stringify_keys

        page_3 = {
          tickets: [{ title: "Ticket 3"}],
          meta: {
            pagination: {
              prev_page: "http://api.groovehq.dev/v1/tickets?page=2",
            }
          }
        }.stringify_keys

        stub_request(:get, "http://api.groovehq.dev/v1/tickets?page=2").
          with(headers: {'Authorization' => 'Bearer phantogram'}).
          to_return(body: page_2.to_json, status: 200)

        stub_request(:get, "http://api.groovehq.dev/v1/tickets?page=3").
          with(headers: {'Authorization' => 'Bearer phantogram'}).
          to_return(body: page_3.to_json, status: 200)

        @page_1 = page_1
      end

      it "enumerates all pages" do
        resource = GrooveHQ::ResourceCollection.new(client, @page_1)

        all_tickets = resource.each.to_a
        expect(all_tickets.size).to eql(3)
        expect(all_tickets.map(&:title)).to eql(["Ticket 1", "Ticket 2", "Ticket 3"])
      end

      it "merges data" do
        resource = GrooveHQ::ResourceCollection.new(client, @page_1)

        expect(resource.map(&:title)).to eql(["Ticket 1", "Ticket 2", "Ticket 3"])
        expect(resource.collection.size).to eql(3)
      end

      it "respects :per_page and other parameters except :page" do
        resource = GrooveHQ::ResourceCollection.new(client, @page_1, page: 1, per_page: 20, foo: "bar")
        stub_request(:get, "http://api.groovehq.dev/v1/tickets?page=2&per_page=20&foo=bar").
          with(headers: {'Authorization' => 'Bearer phantogram'}).
          to_return(body: {tickets: []}.to_json, status: 200)

        expect(resource.map(&:title)).to eql(["Ticket 1"])
      end
    end

  end

end
