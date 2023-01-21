require 'fastlane_core/ui/ui'
require 'fileutils'
require_relative './gcloud_helper'
require_relative './github_helper'

module FirebaseTestLabIntegration
  module Helper
    class IntegrationHelper
      def initialize(platform)
        @platform = platform
      end

      # Performs the actual test run
      def run(params)
        gcloud_helper = ::FirebaseTestLabIntegration::Helper::GcloudHelper.new(@platform, params[:gcp_project], params[:gcp_key_file], params[:gcloud_channel], params[:gcloud_results_bucket], params[:gcloud_results_dir], params[:results_log_file_name], params[:results_download_dir], params[:timeout], params[:quiet])
        gcloud_helper.run_tests(params[:type], params[:app_path], params[:app_path_test], params[:devices], params[:extra_options])
        json = get_test_outcome(params[:results_log_file_name])
        gcloud_helper.download_test_results
        post_github_comment(json, gcloud_helper, params)
      end

      # Prints to terminal outcome of the test run
      def get_test_outcome(log_file_name)
        json = File.read(log_file_name)
        FastlaneCore::UI.message("Test outcome: #{json}")
        JSON.parse(json)
      end

      # Posts a comment to Github PR with the test results
      def post_github_comment(json, gcloud_helper, params)
        owner = params[:github_owner]
        repository = params[:github_repository]
        pr_number = params[:github_pr_number]
        api_token = params[:github_api_token]
        github_helper = ::FirebaseTestLabIntegration::Helper::GithubHelper.new(owner, repository, api_token)

        if github_helper.valid_params?(pr_number)
          FastlaneCore::UI.message("Adding Github comment.")
          prefix, comment = github_helper.generate_comment_content(json, params[:gcp_project], gcloud_helper.results_bucket, gcloud_helper.results_dir, @platform, params[:type])
          github_helper.delete_comments(pr_number, prefix)
          github_helper.put_comment(pr_number, comment)
        else
          FastlaneCore::UI.message("Skipping Github commenting.")
        end
      end

      private :get_test_outcome, :post_github_comment
    end
  end
end
