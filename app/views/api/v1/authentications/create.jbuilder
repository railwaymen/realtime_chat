# frozen_string_literal: true

json.extract! @sign_in_form.user, :id, :email, :authentication_token, :refresh_token
