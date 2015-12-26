
desc "Start Shoryuken worker"
task :worker do
  sh 'bundle exec shoryuken -r ./workers/worker.rb -C ./workers/shoryuken.yml'
end

desc "default config task"
task :config do
  require 'config_env'
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
end

namespace :queue do
  require 'aws-sdk'

  desc "Create Shoryuken queue"
  task :create => [:config] do
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
  require_relative 'models/word'

  desc "Create words table"
  task :migrate => [:config]  do
    begin
      Word.create_table
      puts 'Word table created'
    rescue Aws::DynamoDB::Errors::ResourceInUseException => e
      puts 'Word table already exists'
    end
  end

  task :wipe => [:config]  do
    Word.all.each(&:delete)
  end
end
