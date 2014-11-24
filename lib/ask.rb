require "ask/engine"
require "ask/acts_as_asker"
require "ask/acts_as_answerer"
require "carrierwave"
require "acts_as_list"

module Ask
  require 'ask/configuration'

  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration.new
  end
end
