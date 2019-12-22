#!/bin/bash

source $(dirname "$0")/common.sh

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

xcodebuild -project "$AppProjectFilePath" -scheme "$AppSchema" -archivePath "$AppArchiveRoot" archive | xcpretty || exit 1
cd "$AppArchiveRoot/Products/Library/Audio/Plug-Ins/VST3/WaveLabs" && zip -q --symlinks -r VST3NetSend.vst3.zip VST3NetSend.vst3
