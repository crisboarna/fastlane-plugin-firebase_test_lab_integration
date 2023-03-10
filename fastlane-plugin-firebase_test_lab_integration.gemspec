lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/firebase_test_lab_integration/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-firebase_test_lab_integration'
  spec.version       = Fastlane::FirebaseTestLabIntegration::VERSION
  spec.author        = 'Cristian Boarna'
  spec.email         = 'cristian.boarna@gmail.com'

  spec.summary       = 'Run Android/iOS integration tests on Firebase Test Lab'
  spec.homepage      = "https://github.com/crisboarna/fastlane-plugin-firebase_test_lab_integration"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('dotenv')
  spec.add_development_dependency('fastlane', '>= 2.211.0')
  spec.add_development_dependency('pre-commit')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rspec-mocks')
  spec.add_development_dependency('rubocop', '1.43.0')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-rake')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('rubocop-rspec')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('simplecov-html')
  spec.add_development_dependency('simplecov-lcov')
  spec.metadata['rubygems_mfa_required'] = 'true'
end
