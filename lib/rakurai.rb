require "rakurai/version"

module Rakurai

  require 'servolux'
  require 'sinatra'
  require 'net/http'
  require 'uri'
  require 'optparse'

  autoload :Server, 'rakurai/server'
  autoload :Config, 'rakurai/config'
  autoload :Agent,  'rakurai/agent'

  def self.start
    options = {}
    opt = OptionParser.new
    opt.on('-p VAL', '--port VAL') { |v| options[:port] = v.to_i }
    opt.parse!(ARGV)

    Server.run!(options)
  end
end
