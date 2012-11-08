require 'rack'

module Rakurai
  class Server

    def initialize(config)
      @agent = Agent.new(config.base_uri, config.username, config.password)
    end

    def call(env)
      response = @agent.request(env["REQUEST_METHOD"], env["REQUEST_PATH"])
      header = {}
      response.each do |key, val|
        header[key] = val
      end
      [response.code, header, [response.body]]
    end

  end
end
