require 'shenzhen'
require 'xcpretty'
require 'file/find'

def find_plist(project_name)
  rule = File::Find.new(
    :name => "#{project_name}-Info.plist",
  )
  rule.find{|f|
    puts f
     return f
  }
end

APP_NAME = ENV['APP_NAME'] || "Workshare"
INFO_PLIST = find_plist(APP_NAME)
SDK = "iphoneos"
WORKSPACE = File.expand_path("#{APP_NAME}.xcworkspace")
SCHEME = APP_NAME

testflight_api_token = "TESTFLIGHT_API_TOKEN"
testflight_team_token = "TESTFLIGHT_TEAM_TOKEN"
testflight_distribution_lists = "MY_DISTRIBUTION_LIST"

crashlytics_api_key = "460ce6d7a30b7ab5cd1aa2174d8857445b0976f6"
crashlytics_build_secret = "6585a622f459c3d4b0daac4e19e05a75b9d706eb26097d928bef70d8a94b4e2a"
crashlytics_group_name = "wsconnecttestteam"
crashlytics_framework_path = "Crashlytics.framework"

def run(command, min_exit_status = 0)
  puts "Executing: `#{command}`"
  system(command)
  return $?.exitstatus
end


namespace :version do
  module InfoPlist
    extend self
 
    def [](key)
      output = %x[/usr/libexec/PlistBuddy -c "Print #{key}" #{INFO_PLIST}].strip
      raise "The key `#{key}' does not exist in `#{INFO_PLIST}'." if output.include?('Does Not Exist')
      output
    end
 
    def set(key, value, file = "#{INFO_PLIST}")
      %x[/usr/libexec/PlistBuddy -c 'Set :#{key} "#{value}"' '#{file}'].strip
    end
    def []=(key, value)
      set(key, value)
    end
 
    def build_version
      self['CFBundleVersion']
    end

    def build_version=(revision)
      self['CFBundleVersion'] = revision
    end

    def update_build_number
      self.build_version = (build_version.to_i+1).to_s
    end
  end
 
  desc "Print the current version"
  task :current do
    puts InfoPlist.build_version
  end

  desc "Sets build number to last git commit count (happens on each build)"
  task :update_build_number do
    InfoPlist.update_build_number
  end
 
end

desc "Print the current version"
task :version => 'version:current'

desc "Increment build number"
task :increment_build_number => ['version:current'] do
  InfoPlist.update_build_number
end

desc "Cleaning environment"
task :clean do
  run("rm -rf Build && rm -rf DerivedData && rm -rf Pods && rm -rf Podfile.lock && rm -rf #{WORKSPACE}")
end
 
desc "install dependencies"
task :dependencies do
  run("pod install")
end
 
desc "Run #{SCHEME} tests"
task :run_tests do
  $tests_success = run("xcodebuild -scheme \"#{SCHEME}\" -workspace #{WORKSPACE} -destination 'name=iPhone Retina (4-inch),OS=8.1' clean test | xcpretty -tc; exit ${PIPESTATUS[0]}")
end
 
desc "Clean ipa artefacts"
task :clean_ipa do
  run("rm -rf #{SCHEME}.ipa && rm -rf #{SCHEME}.app.dSYM.zip")
end
 
desc "Upload application to Testflight" 
task :testflight => ['clean','dependencies','run_tests'] do
  if ($tests_success == 0)
    configuration = ENV['configuration']
    configuration ||= "Release"
    puts "Using configuration: " + configuration
    build_status = run("ipa build -s #{SCHEME} --configuration #{configuration}")
    upload_time = Time.now.strftime("%d/%m/%Y")
    upload_status = run("ipa distribute:testflight -a #{testflight_api_token} -T #{testflight_team_token} -l '#{testflight_distribution_lists}' --notify -m '#{SCHEME}-#{configuration} #{upload_time}.'")
    Rake::Task['clean_ipa'].invoke
    exit(-1) unless build_status==0 && upload_status == 0
  else
    puts "\033[0;31m! #{SCHEME} unit tests failed"
    exit(-1)
  end
end

desc "Upload application to CrashLytics" 
task :crashLytics => ['increment_build_number'] do
    configuration = ENV['configuration']
    configuration ||= "Release"
    puts "Using configuration: " + configuration
    build_status = run("ipa build -s #{SCHEME} --configuration #{configuration}")
    # upload_time = Time.now.strftime("%d/%m/%Y")
    upload_status = run("ipa distribute:crashlytics﻿ -a #{crashlytics_api_key} -s #{crashlytics_build_secret} -g #{crashlytics_group_name} -c #{crashlytics_framework_path}")
    Rake::Task['clean_ipa'].invoke
    exit(-1) unless build_status==0 
end

desc "Push version"
task :push_version do
  system("git commit #{INFO_PLIST} -m 'Set version to #{InfoPlist.build_version}'")
  system("git push")
end

desc "Distribute"
task :distribute => [:increment_build_number, :push_version] do
    # Rake::Task["crashLytics"].invoke
end

task default: 'distribute'

