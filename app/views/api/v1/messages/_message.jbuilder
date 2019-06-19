json.extract! message, :id, :user_id, :body, :created_at
json.edited message.edited?

json.editable message.owner?(current_user)
json.user do
  json.username message.user.username
end