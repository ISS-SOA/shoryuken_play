web: bundle exec thin start -R config.ru -p $PORT
worker: bundle exec shoryuken -r ./workers/worker.rb -C ./workers/shoryuken.yml
