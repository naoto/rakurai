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

    def request(method, path)
      url = URI.parse("#{@base_uri}#{path}")
      req = http_request(method, url.path)
      req.basic_auth @username, @password

      @piper = Servolux::Piper.new 'r', :timeout => 30
      @piper.child do
        Net::HTTP.new(url.host, url.port).start do |http|
          http.request(req) do |res|
            response_headers = {}
            res.each_header {|k,v| response_headers[k] = v}
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
        @headers = HeaderHash.new(read_from_child)
      end
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
      chunked = @headers["Transfer-Encoding"] == "chunked"
      term = "\r\n"
      
      while chunk = read_from_child
        break if chunk == :done
        if chunked
          size = bytesize(chunk)
          next if size == 0
          yield [size.to_s(16), term, chunk, term].join
        else
          yield chunk
        end
      end

      yield ["0", term, "", term].join if chunked
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
