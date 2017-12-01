require_relative 'ruby_rest/version'
require 'pry'
require 'mongoid'
require_relative 'ruby_rest/request_helpers'
require_relative 'ruby_rest/dog_client'
require_relative 'ruby_rest/extensions/hash'

Mongoid.load!('mongoid.yml', :development)

# Top level entry point
module RubyRest

  def self.config
    @config ||= OpenStruct.new(bind: '0.0.0.0', port: 8080)
  end

  def self.start_app
    require_relative 'ruby_rest/server'
    Server.run!
  end

  def self.start_server
    require_relative 'ruby_rest/server'
    @thread ||= Thread.new do
      Server.run!
    end
    sleep 1
  end

  def self.stop_server
    Server.stop!
    @thread.join
    @thread = nil
  end

end



