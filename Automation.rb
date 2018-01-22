require_relative "Vendor/WL/Scripts/lib/Core.rb"
require_relative "Vendor/WL/Scripts/lib/Services.rb"
require 'yaml'

class Automation

   XCodeProjectFilePath = ENV['PWD'] + "/VST3NetSend.xcodeproj"
   XCodeProjectSchema = "VST3NetSend"
      
   def self.build()
      XcodeBuilder.new(XCodeProjectFilePath).build(XCodeProjectSchema)
   end
   
   def self.clean()
      XcodeBuilder.new(XCodeProjectFilePath).clean(XCodeProjectSchema)
   end
   
   def self.release()
      # XcodeBuilder.new(XCodeProjectFilePath).archive(XCodeProjectSchema, "Release", true)
      apps = Dir["#{ENV['PWD']}/**/*.xcarchive/**/*.vst3"].select { |f| File.directory?(f) }
      apps.each { |app| Archive.zip(app) }
      apps.each { |app| XcodeBuilder.validateBinary(app) }
   end
   
   def self.verify()
      puts "OK"
      # changedFiles = GitStatus.new(GitRepoDirPath).changedFiles
     #  if Tool.verifyEnvironment("Check Headers")
     #     puts "→ Checking headers..."
     #     puts FileHeaderChecker.new(["VST3NetSend", "WaveLabs"]).analyseFiles(changedFiles)
     #  end
     #  if Tool.canRunSwiftLint()
     #     puts "→ Linting..."
     #     changedFiles.select { |f| File.extname(f) == ".swift" }.each { |f|
     #        puts `swiftlint lint --quiet --config \"#{GitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
     #     }
     #  end
   end
   
   def self.deploy()
      currentDir = ENV['PWD']
      assets = Dir["#{currentDir}/**/*.xcarchive/**/*.vst3.zip"]
      releaseInfo = YAML.load_file("#{currentDir}/Configuration/Release.yml")
      releaseName = releaseInfo['name']
      releaseDescription = releaseInfo['description'].map { |l| "* #{l}"}.join("\n")
      gh = GitHubRepo.new("vgorloff", "VST3NetSend")
      gh.release("1.0.8", releaseName, releaseDescription)
      assets.each { |f| gh.uploadReleaseAsset(f) }
   end

end