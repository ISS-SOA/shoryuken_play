require 'active_support'
require 'active_support/core_ext'

require 'sinatra/base'
require 'slim'
require 'config_env'
require 'aws-sdk'
require_relative 'models/word'
require_relative 'workers/worker'

class Stringifier < Sinatra::Base
  set :server, 'puma'

  configure :development, :test do
    ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
  end

  get '/' do
    slim :input
  end

  post '/input/?' do
    channel_id = (headers.to_s + params.to_s).hash

    input = params[:input]
    words_a = input.gsub(/[^0-9a-z ]/i, '').split
    words_a.map do |word|
      word = create_word(word)
      worker_params = {channel: channel_id, word: word.id}.to_json
      StringWorker.perform_async(worker_params)
    end

    input_s = words_a.join('-')
    redirect "/input/#{input_s}?channel=#{channel_id}"
  end

  get '/input/:input' do
    words_a = params[:input].split('-')
    @words = words_a.map do |word_s|
      Word.where(original: word_s).first
    end

    if channel_id = params[:channel]
      @channel = channel_id
    end

    @strings = [:original, :reversed, :upcase, :downcase, :capitalize]

    slim :words
  end

  def create_word(word)
    word = Word.new(original: word)
    word.save
  end

  run! if app_file == $0
end
