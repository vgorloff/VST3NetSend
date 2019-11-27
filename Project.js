const fs = require('fs');
const Path = require('path');
const AbstractProject = require('wl-scripting').AbstractProject;
const XcodeBuilder = require('wl-scripting').XcodeBuilder;
const FileSystem = require('wl-scripting').FileSystem;
const execute = require('wl-scripting').Functions.execute;
const puts = require('wl-scripting').Functions.puts;

class Project extends AbstractProject {
   constructor(projectDirPath) {
      super(projectDirPath);
      this.projectFilePath = Path.join(this.projectDirPath, 'VST3NetSend.xcodeproj');
      this.projectSchema = 'VST3NetSend-macOS';
      this.vstSDKDirPath = projectDirPath + '/Vendor/Steinberg';
   }

   actions() {
      return ['ci', 'build', 'clean', 'test', 'release', 'verify', 'deploy', 'archive'];
   }

   build() {
      new XcodeBuilder(this.projectFilePath).build(this.projectSchema);
   }

   clean() {
      FileSystem.rmdirIfExists(`${this.projectDirPath}/DerivedData`);
      FileSystem.rmdirIfExists(`${this.projectDirPath}/Build`);
   }

   ci() {
      this.prepare();
      new XcodeBuilder(this.projectFilePath).ci(this.projectSchema);
   }

   prepare() {
      puts('→ Installing packages...');
      execute('npm i ffi ref ref-array');

      puts('→ Downloading dependencies...');
      fs.mkdirSync(this.vstSDKDirPath, { recursive: true });
      process.chdir(this.vstSDKDirPath);
      execute(`git clone --branch vstsdk368_08_11_2017_build_121 https://github.com/steinbergmedia/vst3sdk.git`);
      process.chdir(Path.join(this.vstSDKDirPath, 'vst3sdk'));
      execute(`git submodule update --init base pluginterfaces public.sdk`);
   }
}
