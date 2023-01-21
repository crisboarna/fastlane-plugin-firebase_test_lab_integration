require_relative '../../../../lib/fastlane/plugin/firebase_test_lab_integration/helper/gcloud_helper'

describe FirebaseTestLabIntegration::Helper::GcloudHelper do
  gcp_project = 'gcp_project'
  gcp_key_file = 'gcp_key_file'
  gcloud_channel = 'gcloud_channel'
  gcloud_results_bucket = 'gcloud_results_bucket'
  gcloud_results_dir = 'gcloud_results_dir'
  results_log_file_name = 'results_log_file_name'
  results_download_dir = 'results_download_dir'
  timeout = 'timeout'
  quiet = false
  type = 'type'
  app_path = 'app_path'
  app_path_test = 'app_path_test'
  extra_options = 'extra_options'
  devices = [{
    model: "redfin",
    version: "30",
    locale: "en_US",
    orientation: "portrait"
  }]

  describe '#run_tests' do
    it 'android app test' do
      platform = :android
      expect(Fastlane::Action).to receive(:sh).with("gcloud config set project #{gcp_project}")
      expect(Fastlane::Action).to receive(:sh).with("gcloud auth activate-service-account --key-file #{gcp_key_file} ")
      instance = described_class.new(platform, gcp_project, gcp_key_file, gcloud_channel, gcloud_results_bucket, gcloud_results_dir, results_log_file_name, results_download_dir, timeout, quiet)

      expect(FastlaneCore::UI).to receive(:message).with("Running tests.")
      expect(FastlaneCore::UI).to receive(:message).with("Testing completed.")
      expect(Fastlane::Action).to receive(:sh).with("set +e; gcloud #{gcloud_channel} firebase test #{platform} run --type #{type} --app #{app_path} --test #{app_path_test} --device model=redfin,version=30,locale=en_US,orientation=portrait --timeout #{timeout} --results-bucket #{gcloud_results_bucket} --results-dir #{gcloud_results_dir} #{extra_options} --format=json 1>#{results_log_file_name}; set -e")
      instance.run_tests(type, app_path, app_path_test, devices, extra_options)
    end

    it 'android robo test quiet' do
      platform = :android
      expect(Fastlane::Action).to receive(:sh).with("gcloud config set project #{gcp_project}")
      expect(Fastlane::Action).to receive(:sh).with("gcloud auth activate-service-account --key-file #{gcp_key_file} --no-user-output-enabled")
      instance = described_class.new(platform, gcp_project, gcp_key_file, gcloud_channel, gcloud_results_bucket, gcloud_results_dir, results_log_file_name, results_download_dir, timeout, true)

      expect(FastlaneCore::UI).to receive(:message).with("Running tests.")
      expect(FastlaneCore::UI).to receive(:message).with("Testing completed.")
      expect(Fastlane::Action).to receive(:sh).with("set +e; gcloud #{gcloud_channel} firebase test #{platform} run --type #{type} --app #{app_path} --device model=redfin,version=30,locale=en_US,orientation=portrait --timeout #{timeout} --results-bucket #{gcloud_results_bucket} --results-dir #{gcloud_results_dir} #{extra_options} --format=json 1>#{results_log_file_name}; set -e")
      instance.run_tests(type, app_path, nil, devices, extra_options)
    end

    it 'ios test quiet' do
      platform = :ios
      expect(Fastlane::Action).to receive(:sh).with("gcloud config set project #{gcp_project}")
      expect(Fastlane::Action).to receive(:sh).with("gcloud auth activate-service-account --key-file #{gcp_key_file} --no-user-output-enabled")
      instance = described_class.new(platform, gcp_project, gcp_key_file, gcloud_channel, gcloud_results_bucket, gcloud_results_dir, results_log_file_name, results_download_dir, timeout, true)

      expect(FastlaneCore::UI).to receive(:message).with("Running tests.")
      expect(FastlaneCore::UI).to receive(:message).with("Testing completed.")
      expect(Fastlane::Action).to receive(:sh).with("set +e; gcloud #{gcloud_channel} firebase test #{platform} run --type #{type} --test #{app_path_test} --device model=redfin,version=30,locale=en_US,orientation=portrait --timeout #{timeout} --results-bucket #{gcloud_results_bucket} --results-dir #{gcloud_results_dir} #{extra_options} --format=json 1>#{results_log_file_name}; set -e")
      instance.run_tests(type, nil, app_path_test, devices, extra_options)
    end

    it 'ios test gameloop quiet' do
      platform = :ios
      expect(Fastlane::Action).to receive(:sh).with("gcloud config set project #{gcp_project}")
      expect(Fastlane::Action).to receive(:sh).with("gcloud auth activate-service-account --key-file #{gcp_key_file} --no-user-output-enabled")
      instance = described_class.new(platform, gcp_project, gcp_key_file, gcloud_channel, gcloud_results_bucket, gcloud_results_dir, results_log_file_name, results_download_dir, timeout, true)

      expect(FastlaneCore::UI).to receive(:message).with("Running tests.")
      expect(FastlaneCore::UI).to receive(:message).with("Testing completed.")
      expect(Fastlane::Action).to receive(:sh).with("set +e; gcloud #{gcloud_channel} firebase test #{platform} run --type #{type} --app #{app_path} --test #{app_path_test} --device model=redfin,version=30,locale=en_US,orientation=portrait --timeout #{timeout} --results-bucket #{gcloud_results_bucket} --results-dir #{gcloud_results_dir} #{extra_options} --format=json 1>#{results_log_file_name}; set -e")
      instance.run_tests(type, app_path, app_path_test, devices, extra_options)
    end
  end

  describe '#download_test_results' do
    data = [{ axis_value: 'iphone13pro-15.2-en_US-portrait', outcome: 'Passed', test_details: "1 test cases passed" }]

    it 'given no download_dir' do
      platform = :android
      expect(Fastlane::Action).to receive(:sh).with("gcloud config set project #{gcp_project}")
      expect(Fastlane::Action).to receive(:sh).with("gcloud auth activate-service-account --key-file #{gcp_key_file} --no-user-output-enabled")
      instance = described_class.new(platform, gcp_project, gcp_key_file, gcloud_channel, gcloud_results_bucket, gcloud_results_dir, results_log_file_name, nil, timeout, true)
      expect(FastlaneCore::UI).not_to receive(:message).with("Fetch results from Firebase Test Lab results bucket")
      expect(FastlaneCore::UI).to receive(:message).with("Not fetching results from Firebase Test Lab results bucket")

      instance.download_test_results
    end

    it 'given download_dir and directory not present' do
      platform = :android
      expect(Fastlane::Action).to receive(:sh).with("gcloud config set project #{gcp_project}")
      expect(Fastlane::Action).to receive(:sh).with("gcloud auth activate-service-account --key-file #{gcp_key_file} --no-user-output-enabled")
      expect(FastlaneCore::UI).to receive(:message).with("Fetch results from Firebase Test Lab results bucket")
      expect(FastlaneCore::UI).not_to receive(:message).with("Not fetching results from Firebase Test Lab results bucket")
      allow(File).to receive(:read).and_return(data.to_json)
      expected_dir_name = "#{results_download_dir}/#{data[0].fetch(:axis_value)}"
      allow(File).to receive(:dirname).with(expected_dir_name).and_return(expected_dir_name)
      allow(File).to receive(:directory?).with(expected_dir_name).and_return(false)
      allow(FileUtils).to receive(:mkdir_p).with(expected_dir_name).and_return(nil)
      expect(FastlaneCore::UI).to receive(:message).with("Creating output directory: #{expected_dir_name}.")
      expect(FastlaneCore::UI).to receive(:message).with("Created output directory: #{expected_dir_name}.")
      expect(Fastlane::Action).to receive(:sh).with("gsutil -m -q cp -r gs://#{gcloud_results_bucket}/#{gcloud_results_dir}/#{data[0].fetch(:axis_value)} #{results_download_dir}")
      expect(Fastlane::Action).to receive(:sh).with("gsutil -m -q acl -r set public-read gs://#{gcloud_results_bucket}/#{gcloud_results_dir}/#{data[0].fetch(:axis_value)}")

      instance = described_class.new(platform, gcp_project, gcp_key_file, gcloud_channel, gcloud_results_bucket, gcloud_results_dir, results_log_file_name, results_download_dir, timeout, true)

      instance.download_test_results
    end
  end

  describe '#gcloud_result_bucket_url' do
    it 'returns expected value' do
      expect(described_class.gcloud_result_bucket_url(gcloud_results_bucket, gcloud_results_dir)).to eq("https://console.developers.google.com/storage/browser/#{gcloud_results_bucket}/#{gcloud_results_dir}")
    end
  end

  describe '#gcloud_bucket_object_url' do
    it 'returns expected value' do
      expect(described_class.gcloud_bucket_object_url(gcloud_results_bucket, gcloud_results_dir)).to eq("https://storage.googleapis.com/#{gcloud_results_bucket}/#{gcloud_results_dir}")
    end
  end

  describe '#firebase_test_lab_history_url' do
    it 'returns expected value' do
      expect(described_class.firebase_test_lab_history_url(gcp_project)).to eq("https://console.firebase.google.com/u/0/project/#{gcp_project}/testlab/histories/")
    end
  end
end
