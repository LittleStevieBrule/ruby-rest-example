require 'bundler/setup'
require 'ruby_rest'

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# request class
class Req
  URL = "http://#{RubyRest.config.bind}".freeze
  PORT = RubyRest.config.port
  TOKEN1 = '85f8234563894822c03b9b7ce8c9725aad89f3a5'.freeze
  TOKEN2 = 'afd6e2dfe5fe349b3a19b25ade6b79b73aa6e570'.freeze

  extend RequestHelpers

  # def self.transform_data!(data)
  #   # data.merge!(access_token: TOKEN) unless data[:access_token]
  #   data
  # end

  def self.delete(path, token = TOKEN1)
    super(path + "?access_token=#{token}")
  end

end

