set -eo pipefail

xcodebuild -workspace edu-app.xcworkspace \
           -destination platform=iOS\ Simulator,OS=16.2,name=iPhone\ 14,arch=x86_64 \
           -scheme edu-app \
            clean test | xcpretty --report junit