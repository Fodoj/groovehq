module GrooveHQ
  class Client

    module Tickets

      def tickets_count(options = {})
        get("/tickets/count", options)
      end

      def create_ticket(options)
        post("/tickets", options)
      end

      def ticket(ticket_number)
        get("/tickets/#{ticket_number}")
      end

      def tickets(options = {})
        get("/tickets", options)
      end

      def ticket_state(ticket_number)
        get("/tickets/#{ticket_number}/state")
      end

      def update_ticket_state(ticket_number, state)
        put("/tickets/#{ticket_number}/state", state: state)
      end

      def ticket_assignee(ticket_number)
        get("/tickets/#{ticket_number}/assignee")
      end

      def update_ticket_assignee(ticket_number, assignee)
        put("/tickets/#{ticket_number}/assignee", assignee: assignee)
      end

      def update_ticket_priority(ticket_number, priority)
        put("/tickets/#{ticket_number}/priority", priority: priority)
      end

      def update_ticket_assigned_group(ticket_number, group)
        put("/tickets/#{ticket_number}/assigned_group", group: group)
      end

    end

  end
end
