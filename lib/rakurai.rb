require "rakurai/version"

module Rakurai

  require 'rack'
  require 'servolux'

  require 'rakurai/server'
  require 'rakurai/config'
  require 'rakurai/agent'
  require 'rakurai/response'

  def self.start
    config = Rakurai::Config.load("#{File.dirname(__FILE__)}/../config.yaml")
    @server = Rack::Server.new(
      server: :thin,
      Port: config.port,
      app: Rakurai::Server.new(config)
    )
    @server.start
  end
end
