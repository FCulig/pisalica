set -eo pipefail

xcodebuild -archivePath $PWD/build/edu-app.xcarchive \
           -exportOptionsPlist edu-app/edu-app/exportOptions.plist \
           -exportPath $PWD/build \
           -allowProvisioningUpdates \
           -exportArchive | xcpretty