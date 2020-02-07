#!/bin/bash

source $(dirname "$0")/common.sh

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

ci_prepare() {
   echo '→ Downloading dependencies...'
   rm -rf "$AppVSTSDKDirPath"
   mkdir -p "$AppVSTSDKDirPath"
   cd "$AppVSTSDKDirPath"
   git clone --branch vstsdk368_08_11_2017_build_121 https://github.com/steinbergmedia/vst3sdk.git || exit 1
   cd "$AppVSTSDKDirPath/vst3sdk"
   git submodule update --init base pluginterfaces public.sdk || exit 1
}

ci_prepare
xcodebuild -project "$AppProjectFilePath" -scheme "$AppSchema" CODE_SIGNING_REQUIRED=NO CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= CODE_SIGN_IDENTITY= build | xcpretty

