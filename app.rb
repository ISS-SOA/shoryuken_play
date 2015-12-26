require 'active_support'
require 'active_support/core_ext'

require 'sinatra/base'
require 'slim'
require 'config_env'
require 'aws-sdk'
require_relative 'models/input'
require_relative 'workers/worker'

class Stringifier < Sinatra::Base
  configure :development, :test do
    ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
  end

  get '/' do
    slim :input
  end

  post '/input/?' do
    str = params[:input]
    input = Input.new(original: str)
    input.save

    StringWorker.perform_async(input.id)

    redirect "/input/#{input.id}"
  end

  get '/input/:id' do
    @input = Input.find(params[:id])
    @strings = [:original, :reversed, :upcase, :downcase, :capitalize]

    slim :words
  end

  run! if app_file == $0
end
