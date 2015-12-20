require 'shoryuken'

class MyWorker
  include Shoryuken::Worker

  shoryuken_options queue: 'worker_bee', auto_delete: true

  shoryuken_options body_parser: :json

  def perform(sqs_msg, body)
    puts body
  end
end
