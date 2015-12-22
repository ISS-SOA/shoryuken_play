# Shoryuken Play

A simple demonstration of the Shoryuken worker asynchronously processing job
requests from a Sinatra web application, and updating a DynamoDB table.

## Configuration

To run this app locally, you must get an AWS account, setup an IAM user, and
give it full privileges for SQS and DynamoDB. Notice that the `Rakefile` has
convenient tasks to create your SQS queue and DynamoDB table!

1. Copy the `config/config_env.example.rb` file into `config/config_env.rb`
2. Add your AWS IAM user credentials to `config_env.rb`
3. Create the SQS queue using: `$ rake queue:create`
4. Create the DynamoDB table using: `$rake db:migrate`

## Running

Open two unix terminals.In the first one, run our application:
```
$ bundle exec rackup
```

In the second terminal, run the background worker:
```
$ bundle exec shoryuken -r ./workers/worker.rb -C ./workers/shoryuken.yml
```

Use `Ctrl-c` to kill them when you are done using them (see next section).

## Using

1. Open your browser to `http://localhost:9292/`
2. Fill in the textbox input with any string (such as "Hello World!")
3. Submit the form to request stringification of your input!
4. In the following screen, hit reload once in a while until the worker has
updated the record
5. Notice that after submitting your request, you could bookmark the result page
and return to it any time later (while the worker processes the request).

## Deploy

You may try to deploy this project to Heroku or another PaaS. Setup your Heroku
(or other) project with your AWS environment variables, Notice that `Procfile`
tells Heroku that you need web and worker processes
