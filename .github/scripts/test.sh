set -eo pipefail

xcodebuild -workspace edu-app.xcworkspace \
           -destination platform=iOS\ Simulator,OS=17.2,name=iPhone\ 15,arch=x86_64 \
           -scheme edu-app \
            clean test | xcpretty --report html