desc 'load current profile and dump contents'
task :prof do
  require 'pp'
  require './lib/prof'
  File.open(File.expand_path('~/Library/Application Support/FasterThanLight/prof.sav')) do |file|
    pp Profile.read(file)
  end
end

desc 'load current save and dump contents'
task :continue do
  require 'pp'
  require './lib/prof'
  File.open(File.expand_path('~/Library/Application Support/FasterThanLight/continue.sav')) do |file|
    pp Continue.read(file)
  end
end
