
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_rest/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_rest'
  spec.version       = RubyRest::VERSION
  spec.authors       = ['LittleStevieBrule']
  spec.email         = ['stephendmcguckin@gmail.com']

  spec.summary       = 'Final project for cs496'
  spec.description   = 'A restful api written in ruby using sinatra'
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  #
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'mongoid', '~> 6.1.0'
  spec.add_development_dependency 'octokit'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rest-client'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sinatra', '~> 2.0.0'
  spec.add_runtime_dependency 'bundler', '~> 1.16'
  # spec.add_runtime_dependency 'mongoid', '~> 6.1.0'
  spec.add_runtime_dependency 'octokit'
  spec.add_runtime_dependency 'rake', '~> 10.0'
  spec.add_runtime_dependency 'rest-client'
  spec.add_runtime_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'sinatra', '~> 2.0.0'
end
