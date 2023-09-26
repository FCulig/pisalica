set -eo pipefail

xcodebuild -archivePath $PWD/build/edu-app.xcarchive \
           -exportOptionsPlist edu-app/ExportOptionsAppStore.plist \
           -exportPath $PWD/build \
           -allowProvisioningUpdates \
           -exportArchive | xcpretty