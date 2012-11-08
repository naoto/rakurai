require "rakurai/version"

module Rakurai

  require 'rakurai/server'
  require 'rakurai/config'
  require 'rakurai/agent'

  def self.start
    config = Rakurai::Config.load("#{File.dirname(__FILE__)}/../config.yaml")
    @server = Rack::Server.new(
      server: :webrick,
      Host: local_ip,
      Port: config.port,
      app: Rakurai::Server.new(config)
    )
    @server.start
  end

  private
   # networking - Getting the Hostname or IP in Ruby on Rails - Stack Overflow
   # http://stackoverflow.com/questions/42566/getting-the-hostname-or-ip-in-ruby-on-rails
   def self.local_ip
     # turn off reverse DNS resolution temporarily
     orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true

     UDPSocket.open do |s|
       s.connect('8.8.8.8', 1)
       s.addr.last
     end
   ensure
     Socket.do_not_reverse_lookup = orig
   end
end
