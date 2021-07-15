# frozen_string_literal: true

# json.extract! @user, :id, :username, :name, :email_address, :pfs_number, :admin, :created_at, :updated_at
json.user do
  json.id @user.id
  json.name @user.formal_name
  json.email @user.email
  json.pfs_number @user.org_play_number
  json.created_at @user.created_at
  json.updated_at @user.updated_at
  json.forum_username @user.forum_username
  json.title @user.title
  json.gm_stars @user.gm_stars
  json.event_count @user.user_events&.length
end
