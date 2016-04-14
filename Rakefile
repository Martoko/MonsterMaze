require 'fileutils'

# Find the type of OS being used
module OS
  def self.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def self.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def self.unix?
    !OS.windows?
  end

  def self.linux?
    OS.unix? && !OS.mac?
  end

  def self.arch
    if !(/x64|x86_64/ =~ RUBY_PLATFORM).nil?
      64
    else
      32
    end
  end
end

task default: [:build_osx, :build_win]

SOURCE = Rake::FileList.new('src/*.rb', 'img')

task :build_osx do
  MAC_WRAPPER = Rake::FileList.new('wrappers/Ruby.app/**') do |fl|
    fl.exclude('Contents/Resources/main.rb')
  end

  build_dir = File.join('bin', 'OS_X')
  app_dir = File.join(build_dir, 'MonsterMaze.app')
  app_src_dir = File.join(app_dir, 'Contents', 'Resources')
  infoplist_filename = File.join(app_dir, 'Contents', 'Info.plist')
  mkdir_p app_dir
  FileUtils.cp_r MAC_WRAPPER, app_dir

  infoplist = File.read(infoplist_filename)
  new_infoplist_text = infoplist.gsub(/com.example.Ruby/, 'com.martoko.MonsterMaze')
  File.open(infoplist_filename, 'w') { |file| file.puts new_infoplist_text }

  FileUtils.cp_r SOURCE, app_src_dir
end

task :build_win do
  unless OS.windows?
    puts 'Skipping windows build since we are not on a windows platform'
  end
  build_dir = File.join('bin', 'win' + OS.arch.to_s)
  mkdir_p build_dir

  FileUtils.cp_r Rake::FileList.new('img'), build_dir
  exe_path = File.join('bin', 'win' + OS.arch.to_s, 'MonsterMaze.exe')
  puts %x(ocra --windows --output #{exe_path} #{File.join 'src', 'main.rb'})
end

task :build_ruby do
  build_dir = File.join('bin', 'ruby')
  mkdir_p build_dir

  FileUtils.cp_r SOURCE, build_dir
end
