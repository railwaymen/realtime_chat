json.extract! message, :id, :user_id, :created_at

json.body message.discarded? ? '~~ message has been deleted ~~' : message.body

json.edited message.edited?
json.deleted message.discarded?

json.editable message.owner?(current_user)

json.user do
  json.username message.user.username
end