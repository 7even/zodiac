require 'bundler'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

desc 'Fires up the console with preloaded zodiac'
task :console do
  sh 'irb -I ./lib/ -rubygems -r ./lib/zodiac.rb'
end

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = '--color --format doc'
end
