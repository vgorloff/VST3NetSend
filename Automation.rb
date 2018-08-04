MainFile = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb"
if File.exist?(MainFile)
  require MainFile
else
  Dir[File.dirname(__FILE__) + "/Vendor/WL/Scripts/**/*.rb"].each { |f| require f }
end

class Automation

   GitRepoDirPath = ENV['PWD']
   TmpDirPath = GitRepoDirPath + "/DerivedData"
   KeyChainPath = TmpDirPath + "/VST3NetSend.keychain"
   P12FilePath = GitRepoDirPath + '/Codesign/DeveloperIDApplication.p12'
   XCodeProjectFilePath = GitRepoDirPath + "/VST3NetSend.xcodeproj"
   XCodeProjectSchema = "VST3NetSend"
   VSTSDKDirPath = GitRepoDirPath + "/Vendor/Steinberg"
   VersionFilePath = GitRepoDirPath + "/Configuration/Version.xcconfig"
      
   def self.ci()
      if !Tool.isCIServer
         release()
         return
      end
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "→ Downloading dependencies..."
      FileUtils.mkdir_p VSTSDKDirPath
      `cd \"#{VSTSDKDirPath}\" && git clone --branch vstsdk368_08_11_2017_build_121  https://github.com/steinbergmedia/vst3sdk.git`
      `cd \"#{VSTSDKDirPath}/vst3sdk\" && git submodule update --init base pluginterfaces public.sdk`
      puts "→ Preparing environment..."
      FileUtils.mkdir_p TmpDirPath
      puts Tool.announceEnvVars
      puts "→ Setting up keychain..."
      kc = KeyChain.create(KeyChainPath)
      puts KeyChain.list
      defaultKeyChain = KeyChain.default
      puts "→ Default keychain: #{defaultKeyChain}"
      kc.setSettings()
      kc.info()
      kc.import(P12FilePath, ENV['AWL_P12_PASSWORD'], ["/usr/bin/codesign"])
      kc.setKeyCodesignPartitionList()
      kc.dump()
      KeyChain.setDefault(kc.nameOrPath)
      puts "→ Default keychain now: #{KeyChain.default}"
      begin
         puts "→ Making build..."
         release()
         puts "→ Making cleanup..."
         KeyChain.setDefault(defaultKeyChain)
         KeyChain.delete(kc.nameOrPath)
      rescue
         KeyChain.setDefault(defaultKeyChain)
         KeyChain.delete(kc.nameOrPath)
         puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
         raise
      end
   end
   
   def self.test()
      puts "Nothing to do."
   end
   
   def self.build()
      XcodeBuilder.new(XCodeProjectFilePath).build(XCodeProjectSchema)
   end
   
   def self.clean()
      XcodeBuilder.new(XCodeProjectFilePath).clean(XCodeProjectSchema)
   end
   
   def self.release()
      XcodeBuilder.new(XCodeProjectFilePath).archive(XCodeProjectSchema, nil, true)
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
            l.correctWithSwiftFormat(GitRepoDirPath)
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
      require 'yaml'
      assets = Dir["#{GitRepoDirPath}/**/*.xcarchive/**/*.vst3.zip"]
      releaseInfo = YAML.load_file("#{GitRepoDirPath}/Configuration/Release.yml")
      releaseName = releaseInfo['name']
      releaseDescriptions = releaseInfo['description'].map { |l| "* #{l}"}
      releaseDescription = releaseDescriptions.join("\n")
      version = Version.new(VersionFilePath).projectVersion
      puts "! Will make GitHub release → #{version}: \"#{releaseName}\""
      puts releaseDescriptions.map { |l| "  #{l}" }
      assets.each { |f| puts "  #{f}" }
      gh = GitHubRelease.new("vgorloff", "VST3NetSend")
      Readline.readline("OK? > ")
      gh.release(version, releaseName, releaseDescription)
      assets.each { |f| gh.uploadAsset(f) }
   end

end