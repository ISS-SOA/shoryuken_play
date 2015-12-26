
desc "Start Shoryuken worker"
task :worker do
  sh 'bundle exec shoryuken -r ./workers/worker.rb -C ./workers/shoryuken.yml'
end

namespace :queue do
  require 'aws-sdk'

  desc "Create Shoryuken queue"
  task :create do
    sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])

    begin
      queue = sqs.create_queue(queue_name: 'worker_bee')
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
