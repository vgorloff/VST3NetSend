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
      FileUtils.mkdir_p VSTSDKDirPath
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
      version = Version.new(VersionFilePath).projectVersion
      puts "! Will make GitHub release → #{version}: \"#{releaseName}\""
      puts(releaseDescriptions.map { |line| "  #{line}" })
      assets.each { |file| puts "  #{file}" }
      gh = GitHubRelease.new("vgorloff", "VST3NetSend")
      Readline.readline("OK? > ")
      gh.release(version, releaseName, releaseDescription)
      assets.each { |file| gh.uploadAsset(file) }
   end

   def generate()
      project = XcodeProject.new(projectPath: File.join(@rootDirPath, "Attenuator.xcodeproj"), vendorSubpath: 'WL')
      auHost = project.addApp(name: "AUHost",
                              sources: ["Shared", "SampleAUHost"], platform: :osx, deploymentTarget: "10.11", buildSettings: {
                                 "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.AUHost", "DEPLOYMENT_LOCATION" => "YES"
                              })
      addSharedSources(project, auHost)

      attenuator = project.addApp(name: "Attenuator",
                                  sources: ["Shared", "SampleAUPlugin/Attenuator", "SampleAUPlugin/AttenuatorKit"],
                                  platform: :osx, deploymentTarget: "10.11", buildSettings: {
                                     "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.Attenuator", "DEPLOYMENT_LOCATION" => "YES"
                                  })
      addSharedSources(project, attenuator)

      auExtension = project.addAppExtension(name: "AttenuatorAU",
                                            sources: ["SampleAUPlugin/AttenuatorAU", "SampleAUPlugin/AttenuatorKit"],
                                            platform: :osx, deploymentTarget: "10.11", buildSettings: {
                                               "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.Attenuator.AttenuatorAU",
                                               "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES" => "YES"
                                            })
      addSharedSources(project, auExtension)

      project.addDependencies(to: attenuator, dependencies: [auExtension])
      script = "ruby -r \"$SRCROOT/Project.rb\" -e \"Project.new('$SRCROOT').register()\""
      project.addScript(to: attenuator, script: script, name: "Register Extension", isPostBuild: true)

      project.save()
   end

   def addSharedSources(project, target)
      project.useFilters(target: target, filters: [
                            "Core/Concurrency/*", "Core/Extensions/*", "Core/Converters/*Numeric*",
                            "Core/Sources/AlternativeValue*", "Core/Sources/*Aliases*",
                            "Foundation/os/log/*", "Foundation/Sources/*Info*", "Foundation/Testability/*",
                            "Foundation/ObjectiveC/*", "Foundation/Notification/*",
                            "Foundation/Sources/Functions*", "Foundation/Extensions/CG*", "Foundation/Extensions/*Insets*",
                            "Foundation/Extensions/Color*",
                            "Foundation/Sources/Result*", "Foundation/Sources/Math.swift", "Foundation/Extensions/String*",
                            "Types/Sources/MinMax*", "Types/Sources/Random*", "Types/Sources/Operators*",
                            "Media/Extensions/*", "Media/Sources/Waveform*", "Media/Sources/Media*", "Media/Sources/*Utility*",
                            "Media/Sources/*Type*", "Media/Sources/*Buffer*",
                            "AppKit/Media/Media*", "AppKit/Media/VU*", "AppKit/Media/*DisplayLink*", "AppKit/Media/*Error*",
                            "AppKit/Extensions/*Toolbar*",
                            "Media/DSP/*Value*"
                         ])
   end

end
