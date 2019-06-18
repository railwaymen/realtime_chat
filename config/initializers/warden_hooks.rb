Warden::Manager.after_set_user do |user,auth,opts|
  scope = opts[:scope]
  if Rails.env.staging?
    auth.cookies.signed["#{scope}.id"] = { value: user.id, domain: :all, tld_length: 2 }
  else
    auth.cookies.signed["#{scope}.id"] = { value: user.id }
  end
end

Warden::Manager.before_logout do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = nil
end
