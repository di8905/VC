# frozen_string_literal: true
require "dragonfly"

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "568f4c3000ec1b959843dfa9c2c521fe284eed6beada218b5995c5b766da620e"

  url_format "/media/:job/:name"

  datastore :memory if Rails.env.test?

  if Rails.env.production? || Rails.env.development?
    datastore :s3,
              bucket_name:       ENV["BUCKET_NAME"],
              access_key_id:     ENV["access_key_id"],
              secret_access_key: ENV["secret_access_key"],
              region:            ENV["region"]
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
