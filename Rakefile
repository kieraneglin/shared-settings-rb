require 'bundler/gem_helper'
require 'rake/testtask'

Bundler::GemHelper.install_tasks name: 'shared-settings'
Bundler::GemHelper.install_tasks name: 'shared-settings-ui'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test
