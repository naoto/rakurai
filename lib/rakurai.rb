require "rakurai/version"

module Rakurai

  require 'servolux'
  require 'sinatra'
  require 'net/http'
  require 'uri'

  autoload :Server, 'rakurai/server'
  autoload :Config, 'rakurai/config'
  autoload :Agent,  'rakurai/agent'

  def self.start
    Server.run! :port => 7070
  end
end
