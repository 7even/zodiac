require 'bundler'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

desc 'Fires up the console with preloaded zodiac (and active_record)'
task :console do
  sh 'pry -I ./lib -r active_record -r ./lib/zodiac'
end

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = '--color --format doc'
end

task :default => :spec
