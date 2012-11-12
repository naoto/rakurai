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
    
    def each
      @response.read_body do |body|
        yield body
      end
    end

  end
end

