#!/bin/bash

set -euf -o pipefail

echo "Archive: Started..."
source $(dirname "$0")/common.sh

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

xcodebuild -project "$AppProjectFilePath" -scheme "$AppSchema" -archivePath "$AppArchiveRoot" archive -arch x86_64 -arch arm64 ONLY_ACTIVE_ARCH=NO DEVELOPMENT_TEAM=H3M62US4J7 CODE_SIGN_IDENTITY="Developer ID Application" | xcpretty
cd "$AppArchiveRoot/Products/Library/Audio/Plug-Ins/VST3/Development" && zip -q --symlinks -r VST3NetSend.vst3.zip VST3NetSend.vst3
mv -v VST3NetSend.vst3.zip "$AppBuildRoot"
cd "$AppArchiveRoot" && zip -q --symlinks -r VST3NetSend.vst3.dSYMs.zip dSYMs
mv -v VST3NetSend.vst3.dSYMs.zip "$AppBuildRoot"

echo "Archive: Done!"
