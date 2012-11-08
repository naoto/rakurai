require "rakurai/version"

module Rakurai

  require 'rakurai/server'
  require 'rakurai/config'
  require 'rakurai/agent'

  def self.start
    config = Rakurai::Config.load("#{File.dirname(__FILE__)}/../config.yaml")
    @server = Rack::Server.new(
      server: :webrick,
      Host: "localhost",
      Port: config.port,
      app: Rakurai::Server.new(config)
    )
    @server.start
  end
end
