MAIN_FILE = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb".freeze
if File.exist?(MAIN_FILE)
   require MAIN_FILE
else
   Dir[File.dirname(__FILE__) + "/Vendor/WL/Scripts/**/*.rb"].each { |file| require file }
end

class Project < AbstractProject

   def initialize(rootDirPath)
      super(rootDirPath)
      @tmpDirPath = rootDirPath + "/DerivedData"
      @keyChainPath = @tmpDirPath + "/VST3NetSend.keychain"
      @p12FilePath = rootDirPath + '/Codesign/DeveloperIDApplication.p12'
      @projectFilePath = rootDirPath + "/VST3NetSend.xcodeproj"
      @projectSchema = "VST3NetSend"
      @vstSDKDirPath = rootDirPath + "/Vendor/Steinberg"
      @versionFilePath = rootDirPath + "/Configuration/Version.xcconfig"
   end

   def ci()
      unless Environment.isCI
         release()
         return
      end
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "→ Downloading dependencies..."
      FileUtils.mkdir_p @vstSDKDirPath
      `cd \"#{@vstSDKDirPath}\" && git clone --branch vstsdk368_08_11_2017_build_121  https://github.com/steinbergmedia/vst3sdk.git`
      `cd \"#{@vstSDKDirPath}/vst3sdk\" && git submodule update --init base pluginterfaces public.sdk`
      puts "→ Preparing environment..."
      FileUtils.mkdir_p @tmpDirPath
      puts Environment.announceEnvVars
      puts "→ Setting up keychain..."
      kc = KeyChain.create(@keyChainPath)
      puts KeyChain.list
      defaultKeyChain = KeyChain.default
      puts "→ Default keychain: #{defaultKeyChain}"
      kc.setSettings()
      kc.info()
      kc.import(@p12FilePath, ENV['AWL_P12_PASSWORD'], ["/usr/bin/codesign"])
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
      rescue StandardError
         KeyChain.setDefault(defaultKeyChain)
         KeyChain.delete(kc.nameOrPath)
         puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
         raise
      end
   end

   def build()
      XcodeBuilder.new(@projectFilePath).build(@projectSchema)
   end

   def clean()
      XcodeBuilder.new(@projectFilePath).clean(@projectSchema)
   end

   def release()
      XcodeBuilder.new(@projectFilePath).archive(@projectSchema, nil, true)
      apps = Dir["#{@rootDirPath}/**/*.xcarchive/**/*.vst3"].select { |f| File.directory?(f) }
      apps.each { |app| Archive.zip(app) }
      apps.each { |app| XcodeBuilder.validateBinary(app) }
   end

   def deploy()
      require 'yaml'
      assets = Dir["#{@rootDirPath}/**/*.xcarchive/**/*.vst3.zip"]
      releaseInfo = YAML.load_file("#{@rootDirPath}/Configuration/Release.yml")
      releaseName = releaseInfo['name']
      releaseDescriptions = releaseInfo['description'].map { |l| "* #{l}" }
      releaseDescription = releaseDescriptions.join("\n")
      version = Version.new(@versionFilePath).projectVersion
      puts "! Will make GitHub release → #{version}: \"#{releaseName}\""
      puts(releaseDescriptions.map { |line| "  #{line}" })
      assets.each { |file| puts "  #{file}" }
      gh = GitHubRelease.new("vgorloff", "VST3NetSend")
      Readline.readline("OK? > ")
      gh.release(version, releaseName, releaseDescription)
      assets.each { |file| gh.uploadAsset(file) }
   end

   def generate()
      project = XcodeProject.new(projectPath: File.join(@rootDirPath, "VST3NetSend.xcodeproj"), vendorSubpath: 'WL')
      netSendKit = project.addFramework(name: "VST3NetSendKit",
                                        sources: ["Sources/NetSendKit"], platform: :osx, deploymentTarget: "10.11",
                                        bundleID: "ua.com.wavelabs.vst3.$(PRODUCT_NAME)",
                                        buildSettings: {
                                           "SWIFT_INSTALL_OBJC_HEADER" => "YES",
                                           "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES" => "YES",
                                           "APPLICATION_EXTENSION_API_ONLY" => "YES",
                                           "OTHER_LDFLAGS" => "-framework AudioToolbox",
                                           "DEFINES_MODULE" => "YES",
                                           "LD_RUNPATH_SEARCH_PATHS" => "$(inherited) @executable_path/../Frameworks @loader_path/Frameworks"
                                        })
      project.useFilters(target: netSendKit, filters: [
                            "Core/Formatters/IntegerFormatter*", "Foundation/os/log/*", "Foundation/Sources/*Info*",
                            "Media/Extensions/AudioComponentDescription*", "Media/Sources/AudioUnit*"
                         ])

      netSend = project.addBundle(name: "VST3NetSend",
                                  sources: ["Sources/VST"], platform: :osx, deploymentTarget: "10.11",
                                  bundleID: "ua.com.wavelabs.$(PRODUCT_NAME)",
                                  buildSettings: {
                                     "DSTROOT" => "$(HOME)",
                                     "INSTALL_PATH" => "/Library/Audio/Plug-Ins/VST3/WaveLabs",
                                     "EXPORTED_SYMBOLS_FILE" => "$(GV_VST_SDK)/public.sdk/source/main/macexport.exp",
                                     "WRAPPER_EXTENSION" => "vst3",
                                     "GCC_PREFIX_HEADER" => "Sources/VST/Prefix.h",
                                     "GCC_PREPROCESSOR_DEFINITIONS_Debug" => "DEVELOPMENT=1 $(inherited)",
                                     "GCC_PREPROCESSOR_DEFINITIONS_Release" => "RELEASE=1 NDEBUG=1 $(inherited)",
                                     "DEPLOYMENT_LOCATION" => "YES",
                                     "GENERATE_PKGINFO_FILE" => "YES",
                                     "SKIP_INSTALL" => "NO",
                                     "OTHER_LDFLAGS" => "-framework AudioToolbox -framework CoreAudio -framework Cocoa -framework AudioUnit"
                                  })

      project.addDependencies(to: netSend, dependencies: [netSendKit])
      project.save()
   end

end
