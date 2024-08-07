#!/bin/bash

set -eo pipefail

xcodebuild -workspace edu-app.xcworkspace \
           -scheme edu-app\
           -sdk iphoneos \
           -archivePath $PWD/build/edu-app.xcarchive \
           clean archive | xcpretty