lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'groovehq/version'

Gem::Specification.new do |spec|
  spec.name          = "groovehq"
  spec.version       = GrooveHQ::VERSION
  spec.authors       = ["Kirill Shirinkin"]
  spec.email         = ["fodojyko@gmail.com"]
  spec.summary       = %q{Client library for GrooveHQ API.}
  spec.description   = %q{Client library for GrooveHQ API.}
  spec.homepage      = "https://github.com/Fodoj/groovehq"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency "httparty"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
