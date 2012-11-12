module Rakurai
  class Server

    def initialize(config)
      @agent = Agent.new(config.base_uri, config.username, config.password)
    end

    def call(env)
      req = Rack::Request.new(env)
      @agent.request(req.request_method, req.path)
      [@agent.status, @agent.headers, @agent]
    end

  end
end
