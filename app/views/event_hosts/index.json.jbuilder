# frozen_string_literal: true

json.array! @event_hosts, partial: 'event_hosts/event_host', as: :event_host
