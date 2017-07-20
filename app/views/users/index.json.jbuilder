json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :pfs_number, :created_at, :updated_at, :forum_username, :title, :gm_stars
  json.set! 'event_count', user.user_events&.length
end
