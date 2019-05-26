MAIN_FILE = "#{ENV['AWL_SCRIPTS']}/Automation.rb".freeze
if File.exist?(MAIN_FILE)
   require MAIN_FILE
else
   Dir[File.dirname(__FILE__) + "/Vendor/WL/Scripts/**/*.rb"].each { |file| require file }
end

class Project < AbstractProject

   def initialize(rootDirPath)
      super(rootDirPath)
      @projectFilePath = rootDirPath + "/VST3NetSend.xcodeproj"
   end

   def archive()
      XcodeBuilder.new(@projectFilePath).archive("VST3NetSend-macOS", nil, true)
      apps = Dir["#{@rootDirPath}/**/*.xcarchive/**/*.vst3"].select { |file| File.directory?(file) }
      apps.each { |app| Archive.zip(app) }
      apps.each { |app| XcodeBuilder.validateBinary(app) }
   end

   def deploy()
      require 'yaml'
      assets = Dir["#{@rootDirPath}/**/*.xcarchive/**/*.vst3.zip"]
      gitHubRelease(assets: assets)
   end

   def generate()
      deleteXcodeFiles()
      gen = XCGen.new(@projectFilePath)
      netSendKit = gen.addFramework("VST3NetSendKit", "Sources/NetSendKit", "macOS", false, false)
      netSend = gen.addBundle("VST3NetSend", "Sources/VST", "macOS")
      gen.addComponentFiles(netSendKit, [
                               "IntegerFormatter.swift", "Log.swift", "BuildInfo.swift", "RuntimeInfo.swift", "UnfairLock.swift", "FileManager.swift",
                               "NonRecursiveLocking.swift", "AudioUnitSettings.swift", "String.swift", "String.Index.swift", "AudioComponentDescription.swift"
                            ])
      gen.addBuildSettings(netSendKit, {
                              "SWIFT_INSTALL_OBJC_HEADER" => "YES",
                              "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES" => "YES",
                              "APPLICATION_EXTENSION_API_ONLY" => "YES",
                              "OTHER_LDFLAGS" => "-framework AudioToolbox",
                              "DEFINES_MODULE" => "YES",
                              "LD_RUNPATH_SEARCH_PATHS" => "$(inherited) @executable_path/../Frameworks @loader_path/Frameworks",
                              "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.vst3.$(PRODUCT_NAME)"
                           })
      gen.addBuildSettings(netSend, {
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
                              "OTHER_LDFLAGS" => "-framework AudioToolbox -framework CoreAudio -framework Cocoa -framework AudioUnit",
                              "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.$(PRODUCT_NAME)"
                           })
      gen.addDependencies(netSend, [netSendKit])
      gen.setDeploymentTarget("10.11", "macOS")
      gen.save()
   end

end
