# config/initializers/carrierwave.rb

CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],        # required
    :aws_secret_access_key  => ENV["AWS_ACCESS_KEY"],        # required
    :region					=> 'eu-west-1'
  }
  config.fog_directory  = 'images.thespainreport.com'       # required
  config.fog_use_ssl_for_aws = true
  config.asset_host = "https://s3-eu-west-1.amazonaws.com/#{config.fog_directory}"
end