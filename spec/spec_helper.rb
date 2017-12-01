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
  URL = "http://#{RubyRest::BIND}".freeze
  PORT = RubyRest::PORT
  TOKEN1 = 'dc58167794925fead53375df1df703a1cee5006f'.freeze
  TOKEN2 = 'afd6e2dfe5fe349b3a19b25ade6b79b73aa6e570'.freeze

  extend RequestHelpers

  def self.delete(path, token = TOKEN1)
    super(path + "?access_token=#{token}")
  end

end

