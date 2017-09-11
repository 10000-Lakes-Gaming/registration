json.extract! additional_payment, :id, :category, :description, :price, :payment_amount, :payment_id, :payment_date, :user_event_id, :created_at, :updated_at
json.url additional_payment_url(additional_payment, format: :json)
