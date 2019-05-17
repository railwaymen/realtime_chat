# frozen_string_literal: true

set :rails_env, :staging
set :deploy_to, ENV['CAP_STAGING_DEPLOY_TO']
server ENV['CAP_STAGING_SERVER'], user: ENV['CAP_STAGING_SSH_USER'], roles: %w[app db web]
set :rvm_ruby_version, 'ruby-2.6.1@realtimechat'
set :branch, :master

namespace :deploy do
  after :db, :migrate do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, 'procodile restart --procfile Procfile.staging'
        end
      end
    end
  end
end
