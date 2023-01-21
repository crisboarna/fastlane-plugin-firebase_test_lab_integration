require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

desc 'Run unit specs'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = "--default-path ./spec/unit"
  t.pattern = "./spec/unit/**/*_spec.rb"
end

desc 'Run integration specs'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = "--default-path ./spec/integration"
  t.pattern = "./spec/integration/**/*_spec.rb"
end

require 'rubocop/rake_task'

desc 'Run Rubocop'
RuboCop::RakeTask.new(:rubocop)

desc 'Run semantic release'
task :semantic_release do
  `npx -y -p semantic-release -p @semantic-release/changelog -p semantic-release-rubygem -p @semantic-release/git -p @semantic-release/github --legacy-peer-deps -c semantic-release`
end

desc 'Run fastlane example'
task :fastlane_example do
  `bundle exec fastlane install_plugins && bundle exec fastlane test`
end

task(default: [:spec, :rubocop])
