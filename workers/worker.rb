require 'json'
require 'shoryuken'
require 'config_env'
require 'httparty'
require_relative '../models/word'

env_file = "#{__dir__}/../config/config_env.rb"
ConfigEnv.path_to_config(env_file) unless ENV['AWS_REGION']

class StringWorker
  include Shoryuken::Worker
  shoryuken_options queue: 'worker_bee', auto_delete: true
  TASKS_COUNT = 4

  def perform(sqs_msg, worker_params)
    params = JSON.parse(worker_params)
    word_id = params['word']
    channel_id = params['channel']
    @progress = 0

    word = Word.find(word_id)
    word.reversed = word.original.reverse
    sleep(2)
    publish(channel_id, incr_count)
    word.upcased = word.original.upcase
    sleep(2)
    publish(channel_id, incr_count)
    word.downcased = word.original.downcase
    sleep(2)
    publish(channel_id, incr_count)
    word.capitalized = word.original.capitalize
    sleep(2)
    publish(channel_id, incr_count)
    word.save
  rescue => e
    puts "EXCEPTION: #{e}"
  end

  private

  def incr_count
    (@progress += (100/TASKS_COUNT)).to_s
  end

  def publish(channel, message)
    HTTParty.post('http://localhost:9292/faye', {
        :headers  => { 'Content-Type' => 'application/json' },
        :body    => {
            channel: "/#{channel}",
            data: message
        }.to_json
    })
  end
end
