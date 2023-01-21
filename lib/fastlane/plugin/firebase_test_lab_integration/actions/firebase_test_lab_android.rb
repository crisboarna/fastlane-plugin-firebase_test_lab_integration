require 'fastlane/action'
require 'fastlane_core/ui/ui'
require_relative '../helper/integration_helper'
require_relative '../helper/options'

module Fastlane
  module Actions
    class FirebaseTestLabAndroidAction < Action
      # This method is called by fastlane integration as entrypoint of plugin action
      # It is responsible for calling the actual action logic
      # and handling any errors
      #
      # @param [Hash] options
      def self.run(params)
        FastlaneCore::UI.message("Starting Firebase Test Lab Integration for Android.")
        integration_helper = ::FirebaseTestLabIntegration::Helper::IntegrationHelper.new(:android)
        integration_helper.run(params)
        FastlaneCore::UI.message("Completed Firebase Test Lab Integration for Android.")
      end

      # This method is called by fastlane to display plugin information
      def self.description
        ::FirebaseTestLabIntegration::Helper::Options.description("Android")
      end

      # This method is called by fastlane to display plugin authors
      def self.authors
        ::FirebaseTestLabIntegration::Helper::Options.authors
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        ::FirebaseTestLabIntegration::Helper::Options.details
      end

      def self.available_options
        ::FirebaseTestLabIntegration::Helper::Options.available_options_android
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
