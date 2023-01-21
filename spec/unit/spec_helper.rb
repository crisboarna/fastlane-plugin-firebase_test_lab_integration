$LOAD_PATH.unshift(File.expand_path('../../lib', __dir__))

require 'simplecov'
require 'simplecov-lcov'
require 'simplecov-html'
SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::SimpleFormatter,
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter
  ]
)
SimpleCov.minimum_coverage(80)
SimpleCov.start

# This module is only used to check the environment is currently a testing env
module SpecHelper
end

require 'fastlane' # to import the Action super class
require 'fastlane/plugin/firebase_test_lab_integration' # import the actual plugin

Fastlane.load_actions # load other actions (in case your plugin calls other actions or shared values)
