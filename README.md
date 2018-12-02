### GrooveHQ ruby client library

[![Build Status](https://travis-ci.org/Fodoj/groovehq.svg)](https://travis-ci.org/Fodoj/groovehq)

Client library for talking to [GrooveHQ API](https://www.groovehq.com/docs). Supports all endpoints, as well as chaining API requests for hypermedia links.

#### Usage

First of all, initialize client:

```ruby
client = GrooveHQ::Client.new("MY_API_TOKEN")
```

And then talk to API:

```ruby
client.tickets(page: 2).first.number
```

#### Hypermedia support

Gem supports hypermedia links and allows to chain unlimited amount of requests like this:

```ruby
client.tickets(page: 2).rels[:next].get.first.rels[:customer].get.email
```

#### List of all methods

Client methods really just map 1 to 1 to API, see all of them beyond. Check [the API docs](https://www.groovehq.com/docs) for list of available `options`.

```ruby
agent(email)
agents(options = {})
attachments(message_id)
update_customer(options = {})
customer(email)
customers(options = {})
delete_webhook(id)
folders(options = {})
groups(options = {})
mailboxes(options = {})
create_message(ticket_number, options)
create_webhook(options)
message(message_id)
messages(ticket_number, options = {})
tickets_count(options = {})
create_ticket(options)
ticket(ticket_number)
tickets(options = {})
ticket_state(ticket_number)
update_ticket_state(ticket_number, state)
ticket_assignee(ticket_number)
update_ticket_assignee(ticket_number, assignee)
update_ticket_priority(ticket_number, priority)
update_ticket_assigned_group(ticket_number, assigned_group)
```

