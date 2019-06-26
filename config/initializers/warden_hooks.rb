# frozen_string_literal: true

Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = if Rails.env.staging?
                                         { value: user.id, domain: :all, tld_length: 2 }
                                       else
                                         { value: user.id }
                                       end
end

Warden::Manager.before_logout do |_user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = nil
end
