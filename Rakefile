dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'ginseng/mysql'

namespace :bundle do
  desc 'update gems'
  task :update do
    sh 'bundle update'
  end

  desc 'check gems'
  task :check do
    unless Ginseng::MySQL::Environment.gem_fresh?
      warn 'gems is not fresh.'
      exit 1
    end
  end
end

desc 'test all'
task test: ['tmp:cache:clean'] do
  Ginseng::MySQL::TestCase.load
end

namespace :tmp do
  namespace :cache do
    desc 'clean caches'
    task :clean do
      sh "rm #{File.join(Ginseng::MySQL::Environment.dir, 'tmp/cache/*.gz')}" rescue nil
    end

    desc 'alias of tmp:cache:clean'
    task clear: [:clean]
  end
end
