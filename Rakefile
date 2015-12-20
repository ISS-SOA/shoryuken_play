namespace :queue do
  require 'aws-sdk'

  desc "Create Shoryuken queue"
  task :create do
    sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])

    begin
      queue = sqs.queues.create('RecentCadet')
      puts "Queue created"
    rescue => e
      puts "Error creating queue: #{e}"
    end
  end
end

namespace :db do
  require_relative 'models/input'

  desc "Create tutorial table"
  task :migrate do
    begin
      Input.create_table
      puts 'Tutorial table created'
    rescue Aws::DynamoDB::Errors::ResourceInUseException => e
      puts 'Tutorial table already exists'
    end
  end
end
