require 'fastlane_core/ui/ui'
require 'fastlane_core/configuration/config_item'

module FirebaseTestLabIntegration
  module Helper
    class Options
      def self.description(platform)
        "Run #{platform} integration tests on Firebase Test Lab"
      end

      def self.details
        "Test your app on Firebase Test Lab with ease using fastlane"
      end

      def self.authors
        ["Cristian Boarna"]
      end

      def self.available_options_common
        [
          FastlaneCore::ConfigItem.new(
            key: :gcp_project,
            description: "Google Cloud Platform project ID",
            optional: false,
            type: String,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_GCP_PROJECT"
          ),
          FastlaneCore::ConfigItem.new(
            key: :gcp_key_file,
            description: "Google Cloud Platform authentication key file path",
            optional: false,
            type: String,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_GCP_KEY_FILE"
          ),
          FastlaneCore::ConfigItem.new(
            key: :gcloud_channel,
            description: "If you use beta or alpha channel. Defaults to stable (alpha/beta)",
            optional: true,
            type: String,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_GCP_CHANNEL",
            default_value: "stable"
          ),
          FastlaneCore::ConfigItem.new(
            key: :gcloud_results_bucket,
            description: "Name of Google Storage for Firebase Test Lab results bucket. Defaults to '`gcp_project`_firebase_testlab'",
            optional: true,
            type: String,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_GCP_RESULTS_BUCKET",
            default_value: nil
          ),
          FastlaneCore::ConfigItem.new(
            key: :gcloud_results_dir,
            description: "Name of Google Storage for Firebase Test Lab results directory",
            optional: true,
            type: String,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_GCP_RESULTS_DIR",
            default_value: "firebase_test_lab_result_#{DateTime.now.strftime('%Y-%m-%d-%H:%M:%S')}"
          ),
          FastlaneCore::ConfigItem.new(
            key: :timeout,
            description: "The max time this test execution can run before it is cancelled. Default: 5m (this value must be greater than or equal to 1m)",
            optional: true,
            type: String,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_TIMEOUT",
            default_value: "5m"
          ),
          FastlaneCore::ConfigItem.new(
            key: :quiet,
            description: "Mutes all potentially sensitive `gcloud`, `gsutil` output",
            optional: true,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_QUIET",
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_path_test,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_APP_PATH_TEST",
            description: "The path for your Android test APK. If not present assuming robo test",
            type: String,
            optional: true,
            default_value: nil
          ),
          FastlaneCore::ConfigItem.new(
            key: :type,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_TYPE",
            description: "The type of the test, one of: instrumentation, robo, game-loop, or xctest. Default: depends on platform",
            type: String,
            optional: true,
            verify_block: proc do |value|
              if !value.nil? && value != "robo" && value != "instrumentation" && value != "game-loop" && value != "xctest"
                FastlaneCore::UI.user_error!("Only robo, instrumentation, xctest and game-loop are supported")
              end
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :results_download_dir,
            description: "Target directory to download screenshots from Firebase",
            optional: true,
            type: String,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_RESULTS_DOWNLOAD_DIR",
            default_value: nil
          ),
          FastlaneCore::ConfigItem.new(
            key: :results_log_file_name,
            description: "The filename to save the output results. Default: ./firebase_test_lab_integration.log",
            optional: true,
            type: String,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_OUTPUT_LOG_FILE_NAME",
            default_value: "./firebase_test_lab_integration.log"
          ),
          FastlaneCore::ConfigItem.new(
            key: :github_owner,
            description: "Github Owner name of the repo",
            optional: true,
            type: String,
            env_name: "GH_OWNER",
            default_value: nil
          ),
          FastlaneCore::ConfigItem.new(
            key: :github_repository,
            description: "Github Repository name",
            optional: true,
            type: String,
            env_name: "GH_REPOSITORY",
            default_value: nil
          ),
          FastlaneCore::ConfigItem.new(
            key: :github_pr_number,
            description: "Github Pull request number",
            optional: true,
            type: String,
            env_name: "GH_PR_NUMBER",
            default_value: nil
          ),
          FastlaneCore::ConfigItem.new(
            key: :github_api_token,
            description: "GitHub API Token",
            optional: true,
            type: String,
            env_name: "GH_API_TOKEN",
            default_value: nil
          ),
          FastlaneCore::ConfigItem.new(
            key: :extra_options,
            description: "Extra options that you may pass directly to the `gcloud` command. Default: empty string",
            optional: true,
            type: String,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_EXTRA_OPTIONS",
            default_value: ""
          )
        ]
      end

      def self.available_options_android
        self.available_options_common + [
          FastlaneCore::ConfigItem.new(
            key: :app_path,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_APP_PATH",
            description: "The path to the app to be tested",
            type: String,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :devices,
            description: "Devices to test the app on",
            optional: true,
            type: Array,
            default_value: [{
                              model: "redfin",
                              version: "30",
                              locale: "en_US",
                              orientation: "portrait"
                            }],
            verify_block: proc do |value|
              verify_devices(value)
            end
          )
        ]
      end

      def self.available_options_ios
        self.available_options_common + [
          FastlaneCore::ConfigItem.new(
            key: :app_path,
            env_name: "FIREBASE_TEST_LAB_INTEGRATION_APP_PATH",
            description: "The path to the app to be tested",
            type: String,
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :devices,
            description: "Devices to test the app on",
            optional: true,
            type: Array,
            default_value: [{
                              model: "iphone13pro",
                              version: "15.2",
                              locale: "en_US",
                              orientation: "portrait"
                            }],
            verify_block: proc do |value|
              verify_devices(value)
            end
          )
        ]
      end

      def self.verify_devices(value)
        if value.empty?
          FastlaneCore::UI.user_error!("Devices cannot be empty")
        end
        value.each do |current|
          if current.class != Hash
            FastlaneCore::UI.user_error!("Each device must be represented by a Hash object, " \
                                         "#{current.class} found")
          end
          check_has_property(current, :model)
          check_has_property(current, :version)
          set_default_property(current, :locale, "en_US")
          set_default_property(current, :orientation, "portrait")
        end
      end

      def self.check_has_property(hash_obj, property)
        FastlaneCore::UI.user_error!("Each device must have #{property} property") unless hash_obj.key?(property)
      end

      def self.set_default_property(hash_obj, property, default)
        unless hash_obj.key?(property)
          hash_obj[property] = default
        end
      end
    end
  end
end
