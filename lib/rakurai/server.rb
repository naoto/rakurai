module Rakurai
  class Server

    include Rack::Stream::DSL

    def initialize(config)
      @agent = Agent.new(config.base_uri, config.username, config.password)
    end

    stream do
      body_size = 0
      total_size = 0
      response = @agent.request(env["REQUEST_METHOD"], env["REQUEST_PATH"]) do |b|
        after_open do
          body_size += b.size
          chunk b
          close unless total_size > 0 and body_size < total_size
        end
      end
      total_size = response.header["content-length"].to_i

      [response.code, response.header, []]
    end

  end
end
