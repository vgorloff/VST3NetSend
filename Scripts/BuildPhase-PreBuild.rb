#!/usr/bin/env ruby

gitRepoDirPath = File.expand_path("#{File.dirname(__FILE__)}/../")

require "#{gitRepoDirPath}/Vendor/WL/Conf/Scripts/lib/FileHeaderChecker.rb"
require "#{gitRepoDirPath}/Vendor/WL/Conf/Scripts/lib/Tool.rb"
require "#{gitRepoDirPath}/Vendor/WL/Conf/Scripts/lib/GitStatus.rb"

changedFiles = GitStatus.new(gitRepoDirPath).changedFiles

targetName = ENV['TARGET_NAME']
if targetName == "VST3NetSendKit"
   if Tool.verifyEnvironment("Check Headers")
      puts "→ Checking headers..."
      puts FileHeaderChecker.new(["VST3NetSend", "WaveLabs"]).analyseFiles(changedFiles)
   end
   if Tool.canRunSwiftLint()
      puts "→ Linting..."
      changedFiles.select { |f| File.extname(f) == ".swift" }.each { |f|
         puts `swiftlint lint --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
      }
   end
elsif targetName == "Verify"
   puts `swiftlint lint --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\"`
   puts FileHeaderChecker.new(["VST3NetSend", "WaveLabs"]).analyse(gitRepoDirPath)
end