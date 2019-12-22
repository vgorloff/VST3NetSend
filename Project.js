const fs = require('fs');
const Path = require('path');
const AbstractProject = require('wl-scripting').AbstractProject;
const FileSystem = require('wl-scripting').FileSystem;
const execute = require('wl-scripting').Functions.execute;
const puts = require('wl-scripting').Functions.puts;

class Project extends AbstractProject {
   constructor(projectDirPath) {
      super(projectDirPath);
      this.projectFilePath = Path.join(this.projectDirPath, 'VST3NetSend.xcodeproj');
      this.projectSchema = 'VST3NetSend';
      this.vstSDKDirPath = projectDirPath + '/Vendor/Steinberg';
      this.buildRoot = Path.join(this.projectDirPath, 'Build');
      this.archiveRoot = Path.join(this.buildRoot, 'VST3NetSend.xcarchive');
   }

   ci() {
      this.prepare();
   }

   prepare() {
      puts('→ Downloading dependencies...');
      fs.mkdirSync(this.vstSDKDirPath, { recursive: true });
      process.chdir(this.vstSDKDirPath);
      execute(`git clone --branch vstsdk368_08_11_2017_build_121 https://github.com/steinbergmedia/vst3sdk.git`);
      process.chdir(Path.join(this.vstSDKDirPath, 'vst3sdk'));
      execute(`git submodule update --init base pluginterfaces public.sdk`);
   }
}
