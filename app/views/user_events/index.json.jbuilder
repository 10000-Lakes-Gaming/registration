json.event do
  json.extract! @event, :id, :name, :charity, :price
end
json.registrations do
  json.array!(@user_events) do |user_event|
    json.registration do
      json.extract! user_event, :id, :paid, :payment_id
      if user_event.payment_amount
        json.set! :payment_amount, number_to_currency(user_event.payment_amount.to_i / 100)
      end
    end
    json.user do
      json.extract! user_event.user, :id, :name, :email, :pfs_number, :forum_username, :title, :gm_stars, :show_stars
    end
  end
end
