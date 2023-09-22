#!/bin/bash

set -eo pipefail

#cd ../../

echo "$PWD"

xcodebuild -workspace edu-app.xcworkspace \
           -scheme edu-app\
           -sdk iphoneos \
           -configuration AppStoreDistribution \
           -archivePath $PWD/build/edu-app.xcarchive \
           clean archive | xcpretty