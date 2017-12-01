require_relative 'ruby_rest/version'
require_relative 'ruby_rest/request_helpers'
require_relative 'ruby_rest/dog_client'
require_relative 'ruby_rest/extensions/hash'
require 'ostruct'
require 'json'
require 'mongoid'
require_relative 'ruby_rest/server'
Mongoid.load!('mongoid.yml', :development)


# Top level entry point
module RubyRest

  BIND = '35.196.169.169'
  PORT = 8080

  def self.config
    @config ||= OpenStruct.new(bind: '35.196.169.169', port: 8080)
  end

  def self.tests
    require_relative '../spec/spec_helper'
    RSpec::Core::Runner.run(['../spec/ruby_rest_spec.rb'])
  end

  def self.start_app
    Server.run!
  end

  def self.start_server
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



