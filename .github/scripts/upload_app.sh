set -eo pipefail

xcrun altool --upload-app -t ios -f build/Pisanka.ipa -u "$APPLEID_USERNAME" -p "$APPLEID_PASSWORD" --verbose