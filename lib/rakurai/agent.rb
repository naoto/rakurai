require 'net/http'
require 'uri'

module Rakurai
  class Agent

    include Rack::Utils

    attr_reader :status, :headers

    def initialize(base_uri, username, password)
      @base_uri = base_uri
      @username  = username
      @password  = password
    end

    def request(method, path, env)

      url = URI.parse("#{@base_uri}#{path}")
      req = http_request(method, url.path)
      req.basic_auth @username, @password

      %w(Accept Accept-Encoding Accept-Charset
         X-Requested-With Referer User-Agent Cookie
         Authorization).each do |header|
          key = "HTTP_#{header.upcase.gsub('-', '_')}"
          req[header] = env[key]
      end

      @piper = Servolux::Piper.new 'r', :timeout => 30

      @piper.child do
        Net::HTTP.new(url.host, url.port).start do |http|
          http.request(req) do |res|

            response_headers = {}
            res.each_header {|k,v| 
              response_headers[k] = v unless "accept-ranges" == k.downcase
            }

            @piper.puts res.code.to_i
            @piper.puts response_headers

            res.read_body do |chunk|
              @piper.puts chunk
            end

            @piper.puts :done

          end
        end
      end

      @piper.parent do
        @status = read_from_child
        @headers = read_from_child
      end
      [@status, @headers]
    rescue => e
      if @piper
        @piper.parent { raise }
        @piper.child { @piper.puts e }
      else
        raise
      end
    ensure
      @piper.child { exit!(0) } if @piper
    end

    def each
      while chunk = read_from_child
        break if chunk == :done
        yield chunk
      end
    end

    private
     def http_request(method, path)
       method == "GET" ? ::Net::HTTP::Get.new(path) : ::Net::HTTP::Post.new(path)
     end

     def read_from_child
       val = @piper.gets
       raise val if val.kind_of?(Exception)
       val
     end

  end
end
