require_relative '../../../../lib/fastlane/plugin/firebase_test_lab_integration/helper/gcloud_helper'

describe FirebaseTestLabIntegration::Helper::IntegrationHelper do
  let(:instance) { described_class.new(:ios) }
  let(:gcloud_mock) { instance_double(FirebaseTestLabIntegration::Helper::GcloudHelper) }
  let(:github_mock) { instance_double(FirebaseTestLabIntegration::Helper::GithubHelper) }

  describe '#run' do
    gcp_project = 'gcp_project'
    gcp_key_file = 'gcp_key_file'
    gcloud_channel = 'gcloud_channel'
    gcloud_results_bucket = 'gcloud_results_bucket'
    gcloud_results_dir = 'gcloud_results_dir'
    results_log_file_name = 'results_log_file_name'
    results_download_dir = 'results_download_dir'
    timeout = 'timeout'
    quiet = 'quiet'
    type = 'type'
    app_path = 'app_path'
    app_path_test = 'app_path_test'
    extra_options = 'extra_options'
    devices = {}
    github_owner = 'github_owner'
    github_repository = 'github_repository'
    github_pr_number = 'github_pr_number'
    github_api_token = 'github_api_token'

    params = {
      gcp_project: gcp_project,
      gcp_key_file: gcp_key_file,
      gcloud_channel: gcloud_channel,
      gcloud_results_bucket: gcloud_results_bucket,
      gcloud_results_dir: gcloud_results_dir,
      results_log_file_name: results_log_file_name,
      results_download_dir: results_download_dir,
      timeout: timeout,
      quiet: quiet,
      type: type,
      app_path: app_path,
      app_path_test: app_path_test,
      extra_options: extra_options,
      devices: devices,
      github_owner: github_owner,
      github_repository: github_repository,
      github_pr_number: github_pr_number,
      github_api_token: github_api_token
    }
    data = [{ axis_value: 'iphone13pro-15.2-en_US-portrait', outcome: 'Passed', test_details: "1 test cases passed" }].to_json

    it 'runs tests on iphone without github commenting' do
      allow(FirebaseTestLabIntegration::Helper::GcloudHelper).to receive(:new).with(:ios, gcp_project, gcp_key_file, gcloud_channel, gcloud_results_bucket, gcloud_results_dir, results_log_file_name, results_download_dir, timeout, quiet).and_return(gcloud_mock)
      allow(FirebaseTestLabIntegration::Helper::GithubHelper).to receive(:new).with(github_owner, github_repository, github_api_token).and_return(github_mock)

      allow(gcloud_mock).to receive(:run_tests).with(type, app_path, app_path_test, devices, extra_options).and_return(nil)
      allow(gcloud_mock).to receive(:download_test_results).with(no_args).and_return(nil)
      allow(github_mock).to receive(:valid_params?).with(github_pr_number).and_return(false)
      allow(File).to receive(:read).and_return(data)

      expect(FastlaneCore::UI).to receive(:message).with("Test outcome: #{data}")
      expect(FastlaneCore::UI).to receive(:message).with("Skipping Github commenting.")

      instance.run(params)
    end

    it 'runs tests on iphone with github commenting' do
      prefix = 'prefix'
      comment = 'comment'

      allow(FirebaseTestLabIntegration::Helper::GcloudHelper).to receive(:new).with(:ios, gcp_project, gcp_key_file, gcloud_channel, gcloud_results_bucket, gcloud_results_dir, results_log_file_name, results_download_dir, timeout, quiet).and_return(gcloud_mock)
      allow(FirebaseTestLabIntegration::Helper::GithubHelper).to receive(:new).with(github_owner, github_repository, github_api_token).and_return(github_mock)

      allow(gcloud_mock).to receive(:run_tests).with(type, app_path, app_path_test, devices, extra_options).and_return(nil)
      allow(gcloud_mock).to receive(:download_test_results).with(no_args).and_return(nil)
      allow(gcloud_mock).to receive(:results_bucket).with(no_args).and_return(gcloud_results_bucket)
      allow(gcloud_mock).to receive(:results_dir).with(no_args).and_return(gcloud_results_dir)
      allow(github_mock).to receive(:valid_params?).with(github_pr_number).and_return(true)
      allow(github_mock).to receive(:generate_comment_content).with(JSON.parse(data), gcp_project, gcloud_results_bucket, gcloud_results_dir, :ios, type).and_return([prefix, comment])
      allow(github_mock).to receive(:delete_comments).with(github_pr_number, prefix).and_return(nil)
      allow(github_mock).to receive(:put_comment).with(github_pr_number, comment).and_return(nil)
      allow(File).to receive(:read).and_return(data)

      expect(FastlaneCore::UI).to receive(:message).with("Test outcome: #{data}")
      expect(FastlaneCore::UI).to receive(:message).with("Adding Github comment.")

      instance.run(params)
    end
  end
end
