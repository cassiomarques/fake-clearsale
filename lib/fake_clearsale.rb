ENV["RACK_ENV"] ||= "development"

require "bundler/setup"
Bundler.require

require "yajl/json_gem"
require "settings"
require "app"

module FakeClearsale
  class App < Sinatra::Base
    def redis
      @connection ||= Redis.new(Settings.redis)
      @connection
    end

    configure do
      set :root, File.dirname(__FILE__)
      set :views, settings.root + '/templates'
      set :show_expections, false
    end
  end
end
