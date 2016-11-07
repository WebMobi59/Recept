#!/bin/bash

# Script to build and archive to .ipa with enterprise configuration
# $1 is the provisioning profile that the profile is signed with

# Configuration
IPA_NAME="Recept"
SCHEME="Recept-TC"
PROVISIONING_PROFILE=$1
OUTPUTDIR="dist"

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 PROVISIONING_PROFILE" >&2
  exit 1
fi

# Paths
WORKSPACE="Recept.xcworkspace"
ARCHIVE_PATH="Recept.xcarchive"

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOTDIR=$SCRIPTDIR/..

# Make output dir if not exist
mkdir -p $ROOTDIR/$OUTPUTDIR

# Archive the project
xcodebuild -workspace $ROOTDIR/$WORKSPACE -scheme $SCHEME archive -archivePath $ROOTDIR/$ARCHIVE_PATH -destination generic/platform=iOS

# Remove any existing .ipa with same name
rm "$OUTPUTDIR/$IPA_NAME.ipa" 2> /dev/null || echo > /dev/null

# Export ipa with profile
xcodebuild -exportArchive -exportFormat ipa -archivePath $ROOTDIR/$ARCHIVE_PATH -exportPath "$ROOTDIR/$OUTPUTDIR/$IPA_NAME" -exportProvisioningProfile "$PROVISIONING_PROFILE"
