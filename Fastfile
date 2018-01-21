
def release()
   XcodeBuilder.new(XCodeProjectFilePath).archive(XCodeProjectSchema, "Release", true)
   apps = Dir["#{ENV['PWD']}/**/*.xcarchive/**/*.vst3"].select { |f| File.directory?(f) }
   apps.each { |app| zip(path: app, output_path: "#{app}.zip") }
   apps.each { |app| XcodeBuilder.validateBinary(app) }
end

def deploy()
   assets = Dir["#{ENV['PWD']}/**/*.xcarchive/**/*.vst3.zip"]
   releaseName = File.read("#{ENV['PWD']}/fastlane/ReleaseName.txt").strip
   releaseDescription = File.read("#{ENV['PWD']}/fastlane/ReleaseNotes.txt").strip
   github_release = set_github_release(
     repository_name: "vgorloff/VST3NetSend", api_token: ENV['AWL_GITHUB_TOKEN'], name: releaseName, tag_name: last_git_tag,
     description: releaseDescription, commitish: "master", upload_assets: assets
   )
end

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
