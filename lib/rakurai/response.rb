module Rakurai
  class Response

    def initialize(response)
      @response = response
    end

    def code
      @response.code
    end

    def header
      headers = {}
      @response.each do |key,val| 
        headers[key] = val
      end
      headers
    end
    
    def body(&block)
      block.call @b
    end

    def append(b)
      @b = b
    end

  end
end

