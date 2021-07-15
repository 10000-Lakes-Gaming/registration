# frozen_string_literal: true

json.array! @additional_payments, partial: 'additional_payments/additional_payment', as: :additional_payment
