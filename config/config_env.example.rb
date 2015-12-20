# Skeleton file for true config_env.rb
# - put your keys/secrets in '...'

config_env do
  set 'AWS_ACCESS_KEY_ID', '...'
  set 'AWS_SECRET_ACCESS_KEY', '...'
end

config_env :development, :test do
  # AWS Region: EU Central (Frankfurt)
  set 'AWS_REGION', 'ap-northeast-1'
end

config_env :production do
  # AWS Region: US East (N. Virginia)
  set 'AWS_REGION', 'us-east-1'
end
