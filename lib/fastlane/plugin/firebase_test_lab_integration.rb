require 'fastlane/plugin/firebase_test_lab_integration/version'

module Fastlane
  module FirebaseTestLabIntegration
    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::FirebaseTestLabIntegration.all_classes.each do |current|
  require current
end
