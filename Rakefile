# Releasy requires requires bundler.
require 'fileutils'

# task default:

SOURCE = Rake::FileList.new('*.rb', 'img')
MAC_WRAPPER = Rake::FileList.new('wrappers/Ruby.app/**') do |fl|
  fl.exclude('Contents/Resources/main.rb')
end

task :build_OS_X do
  build_dir = File.join('bin', 'OS_X')
  app_dir = File.join(build_dir, 'MonsterMaze.app')
  app_src_dir = File.join(app_dir, 'Contents', 'Resources')
  infoplist_filename = File.join(app_dir, 'Contents', 'Info.plist')
  mkdir_p app_dir
  FileUtils.cp_r MAC_WRAPPER, app_dir

  infoplist = File.read(infoplist_filename)
  new_infoplist_text = infoplist.gsub(/com.example.Ruby/, 'com.marotko.MonsterMaze')
  # To write changes to the file, use:
  File.open(infoplist_filename, 'w') { |file| file.puts new_infoplist_text }

  FileUtils.cp_r SOURCE, app_src_dir
end

task :build_Windows do
  puts 'TODO'
end
