#!/bin/bash

echo "Build: Started..."
source $(dirname "$0")/common.sh

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

xcodebuild -project "$AppProjectFilePath" -scheme "$AppSchema" build | xcpretty || exit 1
echo "Build: Done!"
