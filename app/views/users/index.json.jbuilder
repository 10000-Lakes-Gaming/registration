json.array!(@users) do |user|
  json.extract! user, :id, :username, :name, :email_address, :pfs_number, :admin
  json.url user_url(user, format: :json)
end
