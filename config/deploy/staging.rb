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
        execute 'systemctl --user restart rpc'
        execute 'systemctl --user restart ws'
      end
    end
  end
end
