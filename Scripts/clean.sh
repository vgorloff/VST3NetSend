#!/bin/bash

source $(dirname "$0")/common.sh

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

rm -rf "$AppBuildRoot"
