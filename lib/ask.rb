require "ask/engine"
require "ask/acts_as_asker"
require "ask/acts_as_answerer"

module Ask
  require 'ask/configuration'

  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration.new
  end
end
