# frozen_string_literal: true
# CarrierWave.configure do |config|
#
#   if Rails.env.test? || Rails.env.test?
#     CarrierWave.configure do |config|
#       config.storage = :file
#     end
#   end
#
#   if Rails.env.production? || Rails.env.development?
#     CarrierWave.configure do |config|
#       config.fog_provider = 'fog/aws'
#     end
#   end
#
#   config.fog_credentials = {
#     provider:              'AWS',                        # required
#     aws_access_key_id:     'AKIAI2J4KVE76DUHBF3Q',       # required
#     aws_secret_access_key: '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', # required
#     region:                'eu-central-1',
#   }
#   config.fog_directory  = 'vc6bucket'
#   config.fog_public     = false
#   config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
# end
