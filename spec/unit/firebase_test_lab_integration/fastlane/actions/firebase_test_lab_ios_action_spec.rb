require_relative '../../../../../lib/fastlane/plugin/firebase_test_lab_integration/helper/integration_helper'

describe Fastlane::Actions::FirebaseTestLabIosAction do
  let(:integration_mock) { instance_double(FirebaseTestLabIntegration::Helper::IntegrationHelper, run: nil) }

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
      devices: {}
    }

    it 'calls deps appropriately' do
      allow(FirebaseTestLabIntegration::Helper::IntegrationHelper).to receive(:new).with(:ios).and_return(integration_mock)
      allow(integration_mock).to receive(:run).with(params).and_return(nil)
      expect(FastlaneCore::UI).to receive(:message).with("Starting Firebase Test Lab Integration for iOS.")
      expect(FastlaneCore::UI).to receive(:message).with("Completed Firebase Test Lab Integration for iOS.")
      described_class.run(params)
    end
  end

  describe '#description' do
    it 'returns correct data' do
      expect(described_class.description).to eq("Run iOS integration tests on Firebase Test Lab")
    end
  end

  describe '#authors' do
    it 'returns correct data' do
      expect(described_class.authors).to eq(["Cristian Boarna"])
    end
  end

  describe '#return_value' do
    it 'returns correct data' do
      expect(described_class.return_value).to be_nil
    end
  end

  describe '#details' do
    it 'returns correct data' do
      expect(described_class.details).to eq("Test your app on Firebase Test Lab with ease using fastlane")
    end
  end

  describe '#available_options' do
    it 'returns correct data' do
      expect(described_class.available_options.length).to eq(18)
    end
  end

  describe '#is_supported' do
    it 'returns correct data' do
      expect(described_class.is_supported?(:ios)).to be(true)
      expect(described_class.is_supported?(:android)).to be(false)
    end
  end
end
