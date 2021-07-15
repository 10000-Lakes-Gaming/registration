# frozen_string_literal: true

json.event do
  json.extract! @event, :id, :name, :charity, :price
end
json.registrations do
  json.array!(@user_events) do |user_event|
    json.registration do
      json.extract! user_event, :id, :paid, :payment_id, :updated_at
      json.set! :payment_amount, number_to_currency(user_event.payment_amount.to_f / 100) if user_event.payment_amount
    end
    json.user do
      json.id user_event.user.id
      json.name user_event.user.name
      json.email user_event.user.email
      json.pfs_number user_event.user.pfs_number
      json.dci_number user_event.user.dci_number
      json.forum_username user_event.user.forum_username
      json.title user_event.user.title
      json.gm_stars user_event.user.gm_stars
      json.formal_name user_event.user.formal_name
      json.formal_name_with_stars user_event.user.formal_name_with_stars
      json.show_stars user_event.user.show_stars
    end
  end
end
