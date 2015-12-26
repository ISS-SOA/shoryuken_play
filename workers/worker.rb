require 'shoryuken'
require 'config_env'
require_relative '../models/word'

env_file = "#{__dir__}/../config/config_env.rb"
ConfigEnv.path_to_config(env_file) unless ENV['AWS_REGION']

class StringWorker
  include Shoryuken::Worker
  shoryuken_options queue: 'worker_bee', auto_delete: true

  def perform(sqs_msg, word_id)
    word = Word.find(word_id)
    word.reversed = word.original.reverse
    word.upcased = word.original.upcase
    word.downcased = word.original.downcase
    word.capitalized = word.original.capitalize
    sleep(3)
    word.save
  rescue => e
    puts "EXCEPTION: #{e}"
  end
end
