module Skimming
  def self.configuration
    @configuration ||= Configuration.new(configuration_hash)
  end

  def self.configuration_hash
    @configuration_hash ||= HashWithIndifferentAccess.new(YAML.load_file('config/skimming.yml'))
  end

  class Configuration
    attr_accessor :associations, :options

    def initialize(configuration_hash)
      @associations = configuration_hash[:associations]
      @options = configuration_hash[:options]
    end
  end
end
