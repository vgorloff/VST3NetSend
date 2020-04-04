#!/bin/bash

echo "Archive: Started..."
source $(dirname "$0")/common.sh

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

xcodebuild -project "$AppProjectFilePath" -scheme "$AppSchema" -archivePath "$AppArchiveRoot" archive | xcpretty || exit 1
cd "$AppArchiveRoot/Products/Library/Audio/Plug-Ins/VST3/Development" && zip -q --symlinks -r VST3NetSend.vst3.zip VST3NetSend.vst3 || exit 1
mv -v VST3NetSend.vst3.zip "$AppBuildRoot" || exit 1

echo "Archive: Done!"
