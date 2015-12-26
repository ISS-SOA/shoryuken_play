require 'dynamoid'

Dynamoid.configure do |config|
  config.adapter = 'aws_sdk_v2'
  config.namespace = "demo_shoryuken"
  config.warn_on_scan = false
  config.read_capacity = 1
  config.write_capacity = 1
end
