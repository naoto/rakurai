require 'net/http'
require 'uri'

module Rakurai
  class Agent

    def initialize(base_uri, username, password)
      @base_uri = base_uri
      @username  = username
      @password  = password
    end

    def request(method, path, &block)
      url = URI.parse("#{@base_uri}#{path}")
      req = http_request(method, url.path)

      req.basic_auth @username, @password

      response = nil
      Net::HTTP.new(url.host, url.port).start do |http|
        http.request(req) do |res|
          response = Rakurai::Response.new(res)
          res.read_body(&block)
        end
      end
      response
    end


    private
     def http_request(method, path)
       method == "GET" ? ::Net::HTTP::Get.new(path) : ::Net::HTTP::Post.new(path)
     end

  end
end
