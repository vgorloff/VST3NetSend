#!/usr/bin/env ruby

GitRepoDirPath = File.expand_path("#{File.dirname(__FILE__)}/../")

require "#{GitRepoDirPath}/Vendor/WL/Conf/Scripts/lib/FileHeaderChecker.rb"
require "#{GitRepoDirPath}/Vendor/WL/Conf/Scripts/lib/Tool.rb"
require "#{GitRepoDirPath}/Vendor/WL/Conf/Scripts/lib/GitStatus.rb"


def verifySources(targetName)
   if targetName == "VST3NetSendKit"
      changedFiles = GitStatus.new(GitRepoDirPath).changedFiles
      if Tool.verifyEnvironment("Check Headers")
         puts "→ Checking headers..."
         puts FileHeaderChecker.new(["VST3NetSend", "WaveLabs"]).analyseFiles(changedFiles)
      end
      if Tool.canRunSwiftLint()
         puts "→ Linting..."
         changedFiles.select { |f| File.extname(f) == ".swift" }.each { |f|
            puts `swiftlint lint --quiet --config \"#{GitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
         }
      end
   elsif targetName == "Verify"
      if Tool.verifyEnvironment("Check Headers")
         puts "→ Checking headers..."
         puts `swiftlint lint --quiet --config \"#{GitRepoDirPath}/.swiftlint.yml\"`
      end
      if Tool.canRunSwiftLint()
         puts "→ Linting..."
         puts FileHeaderChecker.new(["VST3NetSend", "WaveLabs"]).analyse(GitRepoDirPath)
      end
   end
end

verifySources(ENV['TARGET_NAME'])
