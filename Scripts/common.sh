#!/bin/bash

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)

AppSchema=VST3NetSend
AppProjectFilePath=$SrcDirPath/VST3NetSend.xcodeproj
AppVSTSDKDirPath=$SrcDirPath/Vendor/Steinberg
AppBuildRoot=$SrcDirPath/Build
AppArchiveRoot=$AppBuildRoot/VST3NetSend.xcarchive
