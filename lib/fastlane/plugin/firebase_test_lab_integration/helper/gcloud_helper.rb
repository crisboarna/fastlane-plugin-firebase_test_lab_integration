require 'fastlane_core/ui/ui'
require 'fastlane/action'
require 'json'
require 'fileutils'

module FirebaseTestLabIntegration
  module Helper
    class GcloudHelper
      attr_reader :results_bucket, :results_dir

      def initialize(platform, project_id, gcloud_key_file, gcloud_channel, results_bucket, results_dir, log_file_name, download_dir, timeout, quiet)
        @platform = platform
        @project_id = project_id
        @gcloud_key_file = gcloud_key_file
        @gcloud_channel = gcloud_channel
        @results_bucket = results_bucket || "#{project_id}_firebase_testlab"
        @results_dir = results_dir
        @log_file_name = log_file_name
        @download_dir = download_dir
        @timeout = timeout
        @quiet = quiet

        self.authenticate
      end

      # This method is one that perfroms the core action of running the test suite on Firebase Test Lab
      def run_tests(type, app_path, app_path_test, devices, extra_options)
        FastlaneCore::UI.message("Running tests.")
        arguments = "#{"--type #{type} " unless type.nil?}" \
                    "#{"--app #{app_path} " unless app_path.nil?}" \
                    "#{"--test #{app_path_test} " unless app_path_test.nil?}" \
                    "#{devices.map { |d| "--device model=#{d[:model]},version=#{d[:version]},locale=#{d[:locale]},orientation=#{d[:orientation]} " }.join}" \
                    "--timeout #{@timeout} " \
                    "--results-bucket #{@results_bucket} " \
                    "--results-dir #{@results_dir} " \
                    "#{extra_options} " \
                    "--format=json 1>#{generate_directory(@log_file_name)}"
        Fastlane::Action.sh("set +e; gcloud #{@gcloud_channel unless @gcloud_channel == 'stable'} firebase test #{@platform} run #{arguments}; set -e")
        FastlaneCore::UI.message("Testing completed.")
      end

      # This method is one that perfroms the core action of downloading the test results from Firebase Test Lab that were uploaded to Google Cloud Storage
      # It also sets results as public to be accessible from outside
      # It also returns the URL to the results to be used in Github PR comment
      def download_test_results
        if @download_dir
          FastlaneCore::UI.message("Fetch results from Firebase Test Lab results bucket")
          json = JSON.parse(File.read(@log_file_name))
          json.each do |status|
            axis = status["axis_value"]
            generate_directory("#{@download_dir}/#{axis}")
            download_from_gc_storage("#{@results_bucket}/#{@results_dir}/#{axis}", @download_dir)
            gcloud_storage_path_public("#{@results_bucket}/#{@results_dir}/#{axis}")
          end
        else
          FastlaneCore::UI.message("Not fetching results from Firebase Test Lab results bucket")
        end
      end

      def self.gcloud_result_bucket_url(bucket, dir)
        "https://console.developers.google.com/storage/browser/#{bucket}/#{CGI.escape(dir)}"
      end

      def self.gcloud_bucket_object_url(bucket, path)
        "https://storage.googleapis.com/#{bucket}/#{CGI.escape(path)}"
      end

      def self.firebase_test_lab_history_url(project_id)
        "https://console.firebase.google.com/u/0/project/#{project_id}/testlab/histories/"
      end

      # Performs gcloud authentication and project setup
      def authenticate
        FastlaneCore::UI.message("Configuring GCP project.")
        Fastlane::Action.sh("gcloud config set project #{@project_id}")
        FastlaneCore::UI.message("Configured GCP project.")

        FastlaneCore::UI.message("Authenticating with GCP.")
        Fastlane::Action.sh("gcloud auth activate-service-account --key-file #{@gcloud_key_file} #{'--no-user-output-enabled' if @quiet}")
        FastlaneCore::UI.message("Authenticated with GCP.")
      end

      # Generates results output directory for artifacts
      def generate_directory(path)
        dirname = File.dirname(path)
        unless File.directory?(dirname)
          FastlaneCore::UI.message("Creating output directory: #{dirname}.")
          FileUtils.mkdir_p(dirname)
          FastlaneCore::UI.message("Created output directory: #{dirname}.")
        end
        path
      end

      # Downloads artifacts from Google Cloud Storage
      def download_from_gc_storage(bucket_and_path, copy_to)
        FastlaneCore::UI.message("Copy from gs://#{bucket_and_path}")
        Fastlane::Action.sh("gsutil -m #{'-q' if @quiet} cp -r gs://#{bucket_and_path} #{copy_to}")
      end

      # Sets Google Cloud Storage bucket object as public
      def gcloud_storage_path_public(bucket_and_path)
        FastlaneCore::UI.message("Set public for reading gs://#{bucket_and_path} ")
        Fastlane::Action.sh("gsutil -m #{'-q' if @quiet} acl -r set public-read gs://#{bucket_and_path}")
      end

      private :generate_directory, :download_from_gc_storage, :gcloud_storage_path_public
      private_instance_methods :authenticate
    end
  end
end
