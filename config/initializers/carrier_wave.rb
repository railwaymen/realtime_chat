# frozen_string_literal: true

CarrierWave.configure do |config|
  config.enable_processing = false if Rails.env.test?

  if Rails.env.production?
    # config.fog_provider = 'fog/aws'
    # config.fog_credentials = {
    #   provider: 'AWS',
    #   aws_access_key_id: Rails.application.config.env['s3_access_key'],
    #   aws_secret_access_key: Rails.application.config.env['s3_secret_access_key'],
    #   region: Rails.application.config.env['s3_region']
    # }
    # config.storage = :fog
    # config.fog_directory = Rails.application.config.env['s3_bucket']
    # config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
  else
    config.storage = :file
  end
end
