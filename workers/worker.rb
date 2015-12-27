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
  TASKS_COUNT = 5

  def perform(sqs_msg, worker_params)
    params = JSON.parse(worker_params)
    word_id = params['word']
    @channel_id = params['channel']
    @progress = 0

    word = Word.find(word_id)
    word.reversed = word.original.reverse
    update_progress
    word.upcased = word.original.upcase
    update_progress
    word.downcased = word.original.downcase
    update_progress
    word.capitalized = word.original.capitalize
    update_progress
    word.save
    update_progress
  rescue => e
    puts "EXCEPTION: #{e}"
  end

  private

  def update_progress
    sleep(rand(1..3))
    percent = (@progress += (100/TASKS_COUNT)).to_s
    publish(@channel_id, percent)
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
