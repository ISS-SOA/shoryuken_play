require 'shoryuken'
require_relative '../models/input'

class StringWorker
  include Shoryuken::Worker
  shoryuken_options queue: 'worker_bee', auto_delete: true

  def perform(sqs_msg, input_id)
    input = Input.find(input_id)
    input.reversed = input.original.reverse
    input.upcased = input.original.upcase
    input.downcased = input.original.downcase
    input.capitalized = input.original.capitalize
    input.save
  rescue => e
    puts "EXCEPTION: #{e}"
  end
end
