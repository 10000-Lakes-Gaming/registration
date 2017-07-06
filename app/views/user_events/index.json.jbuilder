json.array!(@user_events) do |user_event|
  json.registration do
    json.extract! user_event, :id, :paid, :payment_amount, :payment_id
  end
  json.event do
    json.extract! user_event.event, :id, :name, :charity, :price
  end
  json.user do
    json.extract! user_event.user, :id, :name, :email, :pfs_number, :forum_username
  end
end
