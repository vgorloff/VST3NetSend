import * as FileSystem from 'fs';
import * as Path from 'path';
import * as WL from "wl-scripting";

class Project extends WL.AbstractProject {

   private projectFilePath: string;
   private projectSchema: string;
   private vstSDKDirPath: string;

   constructor(projectDirPath: string) {
      super(projectDirPath)
      this.projectFilePath = Path.join(this.projectDirPath, "VST3NetSend.xcodeproj")
      this.projectSchema = "VST3NetSend-macOS"
      this.vstSDKDirPath = projectDirPath + "/Vendor/Steinberg"
   }

   actions() {
      return ["ci", "build", "clean", "test", "release", "verify", "deploy", "archive"]
   }

   build() {
      new WL.XcodeBuilder(this.projectFilePath).build(this.projectSchema)
   }

   clean() {
      WL.FileSystem.rmdirIfExists(`${this.projectDirPath}/DerivedData`)
      WL.FileSystem.rmdirIfExists(`${this.projectDirPath}/Build`)
   }

   ci() {
      this.prepare()
      new WL.XcodeBuilder(this.projectFilePath).ci(this.projectSchema)
   }

   private prepare() {
      WL.puts("→ Downloading dependencies...")
      FileSystem.mkdirSync(this.vstSDKDirPath, { recursive: true });
      process.chdir(this.vstSDKDirPath)
      WL.execute(`git clone --branch vstsdk368_08_11_2017_build_121 https://github.com/steinbergmedia/vst3sdk.git`)
      process.chdir(Path.join(this.vstSDKDirPath, "vst3sdk"))
      WL.execute(`git submodule update --init base pluginterfaces public.sdk`)
   }

}
