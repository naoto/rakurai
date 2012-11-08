require 'yaml'
require 'ostruct'

module Rakurai
  class Config < OpenStruct

    def self.load(path = "./config.yaml")
      new(YAML.load_file(path))
    end

  end
end
