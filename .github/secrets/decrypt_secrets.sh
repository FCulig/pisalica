#!/bin/sh
set -eo pipefail

gpg --quiet --pinentry loopback --batch --yes --decrypt --passphrase="$IOS_KEYS" --output ./.github/secrets/Pisanka_App_Store_Provisioning_profile.mobileprovision ./.github/secrets/Pisanka_provisioning_profile.mobileprovision.gpg
gpg --quiet --pinentry loopback --batch --yes --decrypt --passphrase="$IOS_KEYS" --output ./.github/secrets/Certificates.p12 ./.github/secrets/Certificates.p12.gpg

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./.github/secrets/Pisanka_App_Store_Provisioning_profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/Pisanka_App_Store_Provisioning_profile.mobileprovision


security create-keychain -p "" build.keychain
security import ./.github/secrets/Certificates.p12 -t agg -k ~/Library/Keychains/build.keychain -P "" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain