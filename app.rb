require 'active_support'
require 'active_support/core_ext'

require 'sinatra/base'
require 'slim'
require 'config_env'
require_relative 'models/input'

class Stringifier < Sinatra::Base
  configure :development, :test do
    ConfigEnv.path_to_config("#{__dir__}/../config/config_env.rb")
  end

  get '/' do
    slim <<-EOF
      html
        title
          Stringifier
        body
          h1 Welcome to Stringifier
          p Enter you string below
          form action='/input' method='POST'
            input type='text' name='input'
            button type='submit' value='btn_input' Stringify!
    EOF
  end

  get '/input/:id' do
    @input = Input.find(params[:id])
    @strings = [:original, :reversed, :upcase, :downcase, :capitalize]

    slim <<-EOF
      html
        title
          Stringifier
        body
          h1 Your Results
          table
            thead
              - @strings.each do |s|
                th = s.to_s
            tbody
              td = @input.original
              td = @input.reversed
              td = @input.upcase
              td = @input.downcase
              td = @input.capitalize
    EOF
  end

  run! if app_file == $0
end
