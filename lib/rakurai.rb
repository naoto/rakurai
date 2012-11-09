require "rakurai/version"

module Rakurai

  require 'rack/stream'

  require 'rakurai/server'
  require 'rakurai/config'
  require 'rakurai/agent'
  require 'rakurai/response'

  def self.start
    config = Rakurai::Config.load("#{File.dirname(__FILE__)}/../config.yaml")
    app = Rack::Builder.app do
      use Rack::Stream
      run Rakurai::Server.new(config)
    end
    app
  end
end
