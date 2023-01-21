<div align="center">
<div>
<h1>Fastlane</h1>
<img alt="logo" src="./docs/images/firebase_test_lab_logo.png" width="100%">
</div>
<h2>
<a href="https://rubygems.org/gems/fastlane-plugin-firebase_test_lab_integration">
  <img alt="fastlane Plugin Badge" src="https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg">
</a>
<a href="https://github.com/crisboarna/fastlane-plugin-firebase_test_lab_integration/actions/workflows/push_main.yaml">
  <img alt="github action workflow" src="https://github.com/crisboarna/fastlane-plugin-firebase_test_lab_integration/actions/workflows/push_main.yaml/badge.svg">
</a>
<a href="https://snyk.io/test/github/crisboarna/fastlane-plugin-firebase_test_lab_integration">
  <img alt="snyk" src="https://snyk.io/test/github/crisboarna/fastlane-plugin-firebase_test_lab_integration/badge.svg?targetFile=Gemfile">
</a>
<a href="https://codecov.io/gh/crisboarna/fastlane-plugin-firebase_test_lab_integration">
  <img alt="codecov" src="https://img.shields.io/codecov/c/github/crisboarna/fastlane-plugin-firebase_test_lab_integration.svg">
</a>
<a href="https://rubygems.org/gems/fastlane-plugin-firebase_test_lab_integration">
  <img alt="npm" src="https://img.shields.io/gem/v/fastlane-plugin-firebase_test_lab_integration.svg">
</a>
<a href="http://opensource.org/licenses/MIT">
  <img alt="license" src="https://img.shields.io/github/license/crisboarna/fastlane-plugin-firebase_test_lab_integration">
</a>
<a href="https://github.com/semantic-release/semantic-release">
  <img alt="semantic-release" src="https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg?style=flat-square)">
</a>
<img src="https://badges.frapsoft.com/os/v1/open-source.svg?v=103">
<a href="https://github.com/crisboarna/fastlane-plugin-firebase_test_lab_integration">
  <img alt="stars" src="https://img.shields.io/github/stars/crisboarna/fastlane-plugin-firebase_test_lab_integration.svg">
</a>
<a href="https://github.com/crisboarna/fastlane-plugin-firebase_test_lab_integration">
  <img alt="issues" src="https://img.shields.io/github/issues/crisboarna/fastlane-plugin-firebase_test_lab_integration.svg">
</a>
<a href="https://github.com/crisboarna">
  <img alt="madeby" src="https://img.shields.io/badge/made%20by-crisboarna-blue.svg" >
</a>
<a href="https://github.com/crisboarna/react-skillbars/pulls">
  <img alt="prs" src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat">
</a>
<br/>
<br/>
</h2>
Comprehensive and easy to use fastlane plugin for Firebase Test Lab integration. Supports both Android and iOS.
<p align="center">
  <a href="#features">Features</a> |
  <a href="#getting-started">Getting Started</a> |
  <a href="#installation">Installation</a> |
  <a href="#issues-and-feedback">Issues &amp; Feedback</a> |
  <a href="#troubleshooting">Troubleshooting</a> |
  <a href="#contributing">Contributing</a> |
  <a href="#license">License</a>
</p>
<img src="docs/images/run_android.gif" />
</div>

## Features

1. Supports both Android and iOS with consistent API
2. No gem dependencies (no issues in the future with incompatibility with other gem versions)
3. Expandable API (you can add your own parameters to the plugin that are passed to underlying `gcloud` command)
4. Unit(80%+) & Integration tests on Firebase Test Lab for Android/iOS
5. Post test results as a comment to Github PRs ([example PR](https://github.com/crisboarna/fastlane-plugin-firebase_test_lab_integration/pull/1))

This fastlane plugin includes the following actions:

| Action                                                                               | Description                                       | Supported Platforms |
|:-------------------------------------------------------------------------------------|:--------------------------------------------------|--------------------:|
| `firebase_test_lab_android`                                                            | Runs Firebase Test Lab for Android APK            |             android |
| `firebase_test_lab_ios`                                                                | Runs Firebase Test Lab for iOS XCTest ad XCUITest |                 ios |

### Parameters

Here is the list of all existing parameters for the actions:

#### `firebase_test_lab_android`

| Key & Env Var                                                                      | Description                                                                                                                                       |
|------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| `gcp_project` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_PROJECT`                    | Google Cloud Platform project ID                                                                                                                  |
| `gcp_key_file` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_KEY_FILE`                  | Google Cloud Platform authentication key file path                                                                                                |
| `gcloud_channel` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_CHANNEL`                 | If you use beta or alpha channel. Defaults to stable (alpha/beta)                                                                                 |
| `gcloud_results_bucket` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_RESULTS_BUCKET`   | Name of Google Storage for Firebase Test Lab results bucket. Defaults to '`gcp_project`_firebase_testlab'                                         |
| `gcloud_results_dir` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_RESULTS_DIR`         | Name of Google Storage for Firebase Test Lab results directory. Defaults to firebase_test_lab_result_#{DateTime.now.strftime('%Y-%m-%d-%H:%M:%S')} |
| `results_download_dir` <br/> `FIREBASE_TEST_LAB_INTEGRATION_RESULTS_DOWNLOAD_DIR`  | Target directory to download screenshots from Firebase.                                                                                           |
| `results_log_file_name` <br/> `FIREBASE_TEST_LAB_INTEGRATION_OUTPUT_LOG_FILE_NAME` | The filename to save the output results. Default: ./firebase_test_lab_integration.log                                                             |
| `timeout` <br/> `FIREBASE_TEST_LAB_INTEGRATION_TIMEOUT`                            | The max time this test execution can run before it is cancelled. Default: 5m (this value must be greater than or equal to 1m)                     |
| `type` <br/> `FIREBASE_TEST_LAB_INTEGRATION_TYPE`                                  | The type of the test, one of: instrumentation, robo, game-loop, or xctest.                                                                        |
| `quiet` <br/> `FIREBASE_TEST_LAB_INTEGRATION_QUIET`                                | Mutes all potentially sensitive `gcloud`, `gsutil` output                                                                                         |
| `app_path` <br/> `FIREBASE_TEST_LAB_INTEGRATION_APP_PATH`                          | The path to the app to be tested.                                                                                                                 |
| `app_path_test` <br/> `FIREBASE_TEST_LAB_INTEGRATION_APP_PATH_TEST`                | The path for your Android test APK. If not present assuming robo test if no type parameter specified.                                             |
| `devices` <br/>`                                                                   | List of devices to test. Defaults to `{model: "redfin",version: "30",locale: "en_US",orientation: "portrait"}`                                                                                                           |
| `github_owner` <br/> `GH_OWNER`                                                    | Github Owner name of the repo                                                                                                                     |
| `github_repository` <br/> `GH_REPOSITORY`                                          | Github Repository name                                                                                                                            |
| `github_pr_number` <br/> `GH_PR_NUMBER`                                            | Github Pull request number                                                                                                                        |
| `github_api_token` <br/> `GH_API_TOKEN`                                            | GitHub API Token                                                                                                                                  |
| `extra_options` <br/> `FIREBASE_TEST_LAB_INTEGRATION_EXTRA_OPTIONS`                | Extra options that you may pass directly to the `gcloud` command. Default: empty string"                                                          |

#### `firebase_test_lab_android`

| Key & Env Var                                                                    | Description                                                                                                                                                           |
|----------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `gcp_project` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_PROJECT`                  | Google Cloud Platform project ID                                                                                                                                      |
| `gcp_key_file` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_KEY_FILE`                | Google Cloud Platform authentication key file path                                                                                                                    |
| `gcloud_channel` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_CHANNEL`                | If you use beta or alpha channel. Defaults to stable (alpha/beta)                                                                                                     |
| `gcloud_results_bucket` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_RESULTS_BUCKET` | Name of Google Storage for Firebase Test Lab results bucket. Defaults to '`gcp_project`_firebase_testlab'                                                             |
| `gcloud_results_dir` <br/> `FIREBASE_TEST_LAB_INTEGRATION_GCP_RESULTS_DIR`       | Name of Google Storage for Firebase Test Lab results directory                                                                                                        |
| `results_download_dir` <br/> `FIREBASE_TEST_LAB_INTEGRATION_RESULTS_DOWNLOAD_DIR` | Target directory to download screenshots from Firebase.                                                                                                               |
| `results_log_file_name` <br/> `FIREBASE_TEST_LAB_INTEGRATION_OUTPUT_LOG_FILE_NAME` | The filename to save the output results. Default: ./firebase_test_lab_integration.log                                                                                 |
| `timeout` <br/> `FIREBASE_TEST_LAB_INTEGRATION_TIMEOUT`                          | The max time this test execution can run before it is cancelled. Default: 5m (this value must be greater than or equal to 1m)                                         |
| `type` <br/> `FIREBASE_TEST_LAB_INTEGRATION_TYPE`                          | The type of the test, one of: instrumentation, robo, game-loop, or xctest.                                                                                            |
| `quiet` <br/> `FIREBASE_TEST_LAB_INTEGRATION_QUIET`                                | Mutes all potentially sensitive `gcloud`, `gsutil` output. If you want to mute `gcloud firebase test` command as well pass `extra_options: --no-user-output-enabled`. |
| `app_path` <br/> `FIREBASE_TEST_LAB_INTEGRATION_APP_PATH`                        | The path to the app to be tested.                                                                                                                                     |
| `devices` <br/>`                      | List of devices to test Defaults to `{model: "iphone13pro",version: "15.2",locale: "en_US",orientation: "portrait"}`                                                  |
| `github_owner` <br/> `GH_OWNER`              | Github Owner name of the repo                                                                                                                                         |
| `github_repository` <br/> `GH_REPOSITORY`              | Github Repository name                                                                                                                                                |
| `github_pr_number` <br/> `GH_PR_NUMBER`              | Github Pull request number                                                                                                                                            |
| `github_api_token` <br/> `GH_API_TOKEN`              | GitHub API Token                                                                                                                                                      |
| `extra_options` <br/> `FIREBASE_TEST_LAB_INTEGRATION_EXTRA_OPTIONS`              | Extra options that you may pass directly to the `gcloud` command allowing full customization of what is executed beyond provided parameters. Default: empty string"   |

## Getting Started
### Step 1. Enable required Google Cloud API's
You need to grant the following two API's to your Google Cloud project:
- [Cloud Testing API](https://console.cloud.google.com/apis/library/testing.googleapis.com)
- [Cloud Tool Results API](https://console.cloud.google.com/apis/library/toolresults.googleapis.com)

### Step 2. Create Google Cloud Service Account & Key
You need to create a Google Cloud Service Account with the *Editor* role and download the JSON key file.
- [Create Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
- [Create Service Account Key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)
- [Grant Service Account Permissions](https://cloud.google.com/iam/docs/granting-roles-to-service-accounts)

### Step 3. Add the Service Account Key to your project
Add the Service Account Key to your project by adding the following line to your `Fastfile`:
```ruby
firebase_test_lab_android(
  ...
    gcp_key_file: "path/to/service_account_key.json"
  ...
)
```

### Step 4. Add gcloud CLI in your environment
You need to add the gcloud CLI in your environment.
You can either install it manually or use prebuild actions available in your CI environment.

For example in `GitHub Actions` you can use the following action:
```yaml
- name: Setup gcloud CLI
  uses: google-github-actions/setup-gcloud@master
  with:
    version: 'latest'
    service_account_key: ${{ secrets.GCP_SA_KEY }}
    project_id: ${{ secrets.GCP_PROJECT_ID }}
```

or manually follow steps below

- [Install gcloud CLI](https://cloud.google.com/sdk/docs/install-sdk)

### Step 5. Enable billing for your Google Cloud project in Firebase
You need to upgrade from basic `Spark` plan in Firebase on your project to be able to use all the required API components for `Firebase Test Lab` (such as `Google Cloud Storage`)

### Step 6. Add plugin to your project
This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started
with `fastlane-plugin-firebase_test_lab_integration`, add it to your project by running:

```bash
fastlane add_plugin firebase_test_lab_integration
```

### Step 7. Find device model names
You can find the device model names as follows:

For Android `firebase_test_lab_android` command:
```bash
gcloud firebase test android models list
```
Alternatively you can see the list of devices [here](https://firebase.google.com/docs/test-lab/android/available-testing-devices)

For iOS `firebase_test_lab_ios` command:
```bash
gcloud firebase test ios models list
```
Alternatively you can see the list of devices [here](https://firebase.google.com/docs/test-lab/ios/available-testing-devices)

## Installation

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-test_center`, add it to your project by running:

```bash
fastlane add_plugin firebase_test_lab_integration
```

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo,
running `bundle exec fastlane install_plugins` and `bundle exec fastlane test`.

## Run tests for this plugin

To run both the tests, and code style validation, run

```bash
bundle exec rake
```

To automatically fix many of the styling issues, use

```
bundle exec rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out
the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out
the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more,
check out [fastlane.tools](https://fastlane.tools).

## Contributing

1. Clone repo and create a new branch:

```shell
git checkout https://github.com/crisboarna/react-skillbars -b name_for_new_branch`.
````

2. Make changes and test
3. Submit Pull Request with comprehensive description of changes

## Bots used

To facilitate development the following bots are integrated into the repository:

1. [Request Info](https://github.com/behaviorbot/request-info)
2. [Semantic Pull Requests](https://github.com/apps/semantic-pull-requests)
3. [Welcome](https://github.com/apps/welcome)
4. [Snyk](https://github.com/marketplace/snyk)
5. [Todo](https://github.com/apps/todo)
6. [Codecov](https://github.com/apps/codecov)

## Credits
Inspired from existing plugin with similar functionality for Android by @wasabeef.