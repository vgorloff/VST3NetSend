require_relative "Vendor/WL/Scripts/lib/Core.rb"

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
      assets = Dir["#{ENV['PWD']}/**/*.xcarchive/**/*.vst3.zip"]
      releaseName = File.read("#{ENV['PWD']}/Configuration/ReleaseName.txt").strip
      releaseDescription = File.read("#{ENV['PWD']}/Configuration/ReleaseNotes.txt").strip
      puts assets
      puts releaseName
      puts releaseDescription
      # github_release = set_github_release(
#         repository_name: "vgorloff/VST3NetSend", api_token: ENV['AWL_GITHUB_TOKEN'], name: releaseName, tag_name: last_git_tag,
#         description: releaseDescription, commitish: "master", upload_assets: assets
#       )
   end

end