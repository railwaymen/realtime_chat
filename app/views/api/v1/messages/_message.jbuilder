json.extract! message, :id, :user_id, :body, :updated_at, :created_at
json.editable message.owner?(current_user)
json.user do
  json.username message.user.username
end