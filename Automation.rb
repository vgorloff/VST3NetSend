mainFile = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb"
if File.exist?(mainFile)
   require 'yaml'
   require mainFile
else
   require_relative "Vendor/WL/Scripts/lib/Core.rb"
end

class Automation

   GitRepoDirPath = ENV['PWD']
   XCodeProjectFilePath = GitRepoDirPath + "/VST3NetSend.xcodeproj"
   XCodeProjectSchema = "VST3NetSend"
      
   def self.build()
      XcodeBuilder.new(XCodeProjectFilePath).build(XCodeProjectSchema)
   end
   
   def self.clean()
      XcodeBuilder.new(XCodeProjectFilePath).clean(XCodeProjectSchema)
   end
   
   def self.release()
      XcodeBuilder.new(XCodeProjectFilePath).archive(XCodeProjectSchema, "Release", true)
      apps = Dir["#{GitRepoDirPath}/**/*.xcarchive/**/*.vst3"].select { |f| File.directory?(f) }
      apps.each { |app| Archive.zip(app) }
      apps.each { |app| XcodeBuilder.validateBinary(app) }
   end
   
   def self.verify()
      if Tool.isCIServer
         return
      end
      t = Tool.new()
      l = Linter.new(GitRepoDirPath)
      h = FileHeaderChecker.new(["VST3NetSend", "WaveLabs"])
      if t.isXcodeBuild
         if t.canRunActions("Verification")
            changedFiles = GitStatus.new(GitRepoDirPath).changedFiles()
            puts "→ Checking headers..."
            puts h.analyseFiles(changedFiles)
            if l.canRunSwiftLint()
               puts "→ Linting..."
               l.lintFiles(changedFiles)
            end
         end
      else
         puts h.analyseDir(GitRepoDirPath)
         if l.canRunSwiftFormat()
            puts "→ Correcting sources (SwiftFormat)..."
            l.correctWithSwiftFormat()
         end
         if l.canRunSwiftLint()
            puts "→ Correcting sources (SwiftLint)..."
            l.correctWithSwiftLint()
         end
      end
   end
   
   def self.deploy()
      if Tool.isCIServer
         return
      end
      assets = Dir["#{GitRepoDirPath}/**/*.xcarchive/**/*.vst3.zip"]
      releaseInfo = YAML.load_file("#{GitRepoDirPath}/Configuration/Release.yml")
      releaseName = releaseInfo['name']
      releaseDescription = releaseInfo['description'].map { |l| "* #{l}"}.join("\n")
      gh = GitHubRepo.new("vgorloff", "VST3NetSend")
      gh.release("1.0.8", releaseName, releaseDescription)
      assets.each { |f| gh.uploadReleaseAsset(f) }
   end

end