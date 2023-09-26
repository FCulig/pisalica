set -eo pipefail

xcodebuild -archivePath $PWD/build/edu-app.xcarchive \
           -exportOptionsPlist edu-app/ExportOptionsTestFlight.plist \
           -exportPath $PWD/build \
           -allowProvisioningUpdates \
           -exportArchive | xcpretty