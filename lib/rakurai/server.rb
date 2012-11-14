module Rakurai
  class Server < Sinatra::Base

    set :protection, :except => [:frame_options, :xss_header]
    
    configure do
      @@config = Config::load("#{File.dirname(__FILE__)}/../../config.yaml")
    end

    get '/*' do
      puts request.path
      @agent = Agent.new(@@config.base_uri, @@config.username, @@config.password)
      @status, @headers = @agent.request(request.request_method, request.path, request.env)

      response.status = @status
      @headers.each do |k,v|
        key = k.split("-").map do |x| x.gsub!(/^(.)/){ |w| w.upcase! }  end.join("-")
        headers[key] =v
      end

      stream do |out|
        @agent.each do |data|
          out << data
        end
      end

    end

  end
end
