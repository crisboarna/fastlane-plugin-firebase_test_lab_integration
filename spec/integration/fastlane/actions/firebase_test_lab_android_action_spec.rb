require 'fileutils'
require 'json'

describe Fastlane::Actions::FirebaseTestLabAndroidAction do
  describe '#run integration android' do
    it 'runs firebase test lab android integration' do
      described_class.run({
                            gcp_project: ENV.fetch('FIREBASE_TEST_LAB_INTEGRATION_GCP_PROJECT', nil),
                            gcp_key_file: ENV.fetch('FIREBASE_TEST_LAB_INTEGRATION_GCP_KEY_FILE', nil),
                            gcloud_results_bucket: ENV.fetch('FIREBASE_TEST_LAB_INTEGRATION_GCP_RESULTS_BUCKET', nil),
                            gcloud_results_dir: ENV.fetch('FIREBASE_TEST_LAB_INTEGRATION_GCP_RESULTS_DIR', nil),
                            results_download_dir: "./test-results",
                            results_log_file_name: "./test-results/test-lab-android-output.log",
                            timeout: ENV.fetch('FIREBASE_TEST_LAB_INTEGRATION_TIMEOUT', nil),
                            app_path: 'spec/integration/fixtures/android/app-debug.apk',
                            app_path_test: 'spec/integration/fixtures/android/app-debug-androidTest.apk',
                            devices: [
                              {
                                model: 'redfin',
                                version: '30',
                                locale: 'en_US',
                                orientation: 'portrait'
                              }
                            ],
                            github_owner: ENV.fetch('GH_OWNER', nil),
                            github_repository: ENV.fetch('GH_REPOSITORY', nil),
                            github_pr_number: ENV.fetch('GH_PR_NUMBER', nil),
                            github_api_token: ENV.fetch('GH_API_TOKEN', nil)
                          })
      outcome_file = JSON.parse(File.read("./test-results/test-lab-android-output.log"))
      expect(outcome_file[0]['outcome']).to eq('Passed')
    end
  end
end
