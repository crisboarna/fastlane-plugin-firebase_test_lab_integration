require 'fastlane_core/ui/ui'
require 'json'
require_relative './gcloud_helper'

module FirebaseTestLabIntegration
  module Helper
    class GithubHelper
      PASSED = 'Passed'
      FAILED = 'Failed'
      SKIPPED = 'Skipped'
      INCONCLUSIVE = 'Inconclusive'

      def initialize(owner, repository, api_token)
        @owner = owner
        @repository = repository
        @api_token = api_token
      end

      def valid_params?(pr_number)
        !@owner.nil? && !@owner.empty? && !@repository.nil? && !@repository.empty? && !pr_number.nil? && !pr_number.empty? && !@api_token.nil? && !@api_token.empty?
      end

      def fold_comments(github_pr_number, comment_prefix, summary)
        res = get_comments(github_pr_number)
        JSON.parse(res.body)
            .select { |comment| comment["body"].start_with?(comment_prefix) }
            .each do |comment|
              body = "<details><summary>#{summary}</summary>\n\n#{comment['body']}\n\n</details>\n"
              patch_comment(comment["id"], body)
            end
      end

      def delete_comments(github_pr_number, comment_prefix)
        FastlaneCore::UI.message("Deleting old Github comments.")
        res = get_comments(github_pr_number)
        JSON.parse(res.body)
            .select { |comment| comment["body"].start_with?(comment_prefix) }
            .each { |comment| delete_comment(comment["id"]) }
      end

      def get_comments(github_pr_number)
        api_url = "https://api.github.com/repos/#{@owner}/#{@repository}/issues/#{github_pr_number}/comments"
        FastlaneCore::UI.message("get comments #{api_url}")

        uri = URI.parse(api_url)
        req = Net::HTTP::Get.new(uri)
        req["Content-Type"] = "application/json"
        req["Authorization"] = "token #{@api_token}"

        res = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: uri.scheme = "https" }) { |http| http.request(req) }
        FastlaneCore::UI.message("#{res.code}\n#{res.body}")

        res
      end

      def put_comment(github_pr_number, body)
        FastlaneCore::UI.message("Adding Github comments.")
        api_url = "https://api.github.com/repos/#{@owner}/#{@repository}/issues/#{github_pr_number}/comments"
        FastlaneCore::UI.message("put comment #{api_url}")

        uri = URI.parse(api_url)
        req = Net::HTTP::Post.new(uri)
        req["Content-Type"] = "application/json"
        req["Authorization"] = "token #{@api_token}"
        req.body = { body: body }.to_json

        res = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: uri.scheme = "https" }) { |http| http.request(req) }
        FastlaneCore::UI.message("#{res.code}\n#{res.body}")

        res
      end

      def patch_comment(comment_id, body)
        api_url = "https://api.github.com/repos/#{@owner}/#{@repository}/issues/comments/#{comment_id}"
        FastlaneCore::UI.message("patch comment #{api_url}")

        uri = URI.parse(api_url)
        req = Net::HTTP::Patch.new(uri)
        req["Content-Type"] = "application/json"
        req["Authorization"] = "token #{@api_token}"
        req.body = { body: body }.to_json

        res = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: uri.scheme = "https" }) { |http| http.request(req) }
        FastlaneCore::UI.message("#{res.code}\n#{res.body}")

        res
      end

      def delete_comment(comment_id)
        api_url = "https://api.github.com/repos/#{@owner}/#{@repository}/issues/comments/#{comment_id}"
        FastlaneCore::UI.message("Deleting Github comment #{api_url}")

        uri = URI.parse(api_url)
        req = Net::HTTP::Delete.new(uri)
        req["Content-Type"] = "application/json"
        req["Authorization"] = "token #{@api_token}"

        res = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: uri.scheme = "https" }) { |http| http.request(req) }
        FastlaneCore::UI.message("#{res.code}\n#{res.body}")

        res
      end

      def generate_comment_content(json, project_id, bucket, dir, platform, test_type)
        prefix = "<img alt=\"#{platform}\" src=\"https://github.com/crisboarna/fastlane-plugin-firebase_test_lab_integration/blob/master/docs/firebase_test_lab_logo.png?raw=true\" width=\"65%\" loading=\"lazy\" />"
        cells = json.map do |data|
          axis = data["axis_value"]
          device = split_device_name(axis)
          outcome = data["outcome"]
          status = "#{emoji_status(outcome)} #{outcome}"
          message = data["test_details"]
          logcat = "<a href=\"#{::FirebaseTestLabIntegration::Helper::GcloudHelper.gcloud_bucket_object_url(bucket, "#{dir}/#{axis}/logcat")}\" target=\"_blank\" >#{random_emoji_cat}</a>"
          if platform == :android
            if test_type == "robo"
              sitemp = "<img src=\"#{::FirebaseTestLabIntegration::Helper::GcloudHelper.gcloud_bucket_object_url(bucket, "#{dir}/#{axis}/artifacts/sitemap.png")}\" height=\"64px\" loading=\"lazy\" target=\"_blank\" />"
            else
              sitemp = "--"
            end
          end

          "| **#{device}** | #{status} | #{message} | #{logcat} | #{"#{sitemp} |" unless platform == 'ios'} |\n"
        end.inject(&:+)
        comment = <<~EOS
          #{prefix}

          ### Results
          Firebase console: [#{project_id}](#{::FirebaseTestLabIntegration::Helper::GcloudHelper.firebase_test_lab_history_url(project_id)})#{' '}
          Test results: [#{dir}](#{::FirebaseTestLabIntegration::Helper::GcloudHelper.gcloud_result_bucket_url(bucket, dir)})

          | :iphone: Device | :thermometer: Status | :memo: Message | :eyes: Logcat | :japan: Sitemap |#{' '}
          | --- | :---: | --- | :---: | :---: |
          #{cells}
        EOS
        return prefix, comment
      end

      def split_device_name(axis_value)
        # Sample Nexus6P-23-ja_JP-portrait
        array = axis_value.split("-")
        "#{array[0]} (API #{array[1]})"
      end

      def emoji_status(outcome)
        return case outcome
               when PASSED
                 ":tada:"
               when FAILED
                 ":fire:"
               when INCONCLUSIVE
                 ":warning:"
               when SKIPPED
                 ":expressionless:"
               else
                 ":question:"
               end
      end

      def random_emoji_cat
        %w(:smiley_cat: :smile_cat: :joy_cat: :heart_eyes_cat: :smirk_cat: :kissing_cat:).sample
      end

      private :split_device_name, :emoji_status, :random_emoji_cat
    end
  end
end
