require 'shoryuken'
require 'config_env'
require_relative '../models/input'

env_file = "#{__dir__}/../config/config_env.rb"
ConfigEnv.path_to_config(env_file) unless ENV['AWS_REGION']

class StringWorker
  include Shoryuken::Worker
  shoryuken_options queue: 'worker_bee', auto_delete: true

  def perform(sqs_msg, input_id)
    input = Input.find(input_id)
    input.reversed = input.original.reverse
    input.upcased = input.original.upcase
    input.downcased = input.original.downcase
    input.capitalized = input.original.capitalize
    sleep(5)
    input.save
  rescue => e
    puts "EXCEPTION: #{e}"
  end
end
