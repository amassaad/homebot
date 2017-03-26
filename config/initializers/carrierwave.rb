CarrierWave.configure do |config|
  config.fog_provider = 'fog'
  config.fog_credentials = {
    provider:               'AWS',
    region:                 'us-west-2',
    aws_access_key_id:      ENV['S3_ID'],
    aws_secret_access_key:  ENV['S3_KEY']
  }
  config.fog_public = true
  config.fog_directory  = 'hydro-bot'
end
