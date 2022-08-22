#!/bin/bash

SCRIPT_NAME="Publishing on CocoaPods"

echo
echo "------------------------------------------------------------------"
echo "INSTALL START"
echo "Installing version $VERSION in Local SDK at $PUBLIC_PROJECT_DIR/AxeptioSDK"
echo

XCODE="Xcode.app"
echo
echo "------------------------------------------------------------------"
echo "I$SCRIPT_NAME Stage 1 - Checking required Xcode version : $XCODE"
echo

XCODEPATH="/Applications/$XCODE"
if [ ! -d "$XCODEPATH" ]; then
	echo "$XCODE is not installed, please install it first"
	exit 1
fi

sudo xcode-select -s "/Applications/$XCODE"
sudo xcode-select -p "/Applications/$XCODE/Contents/Developer"

echo
echo "------------------------------------------------------------------"
echo "$SCRIPT_NAME Stage 2 - Cocoapods Pods Checking"
echo

#PATH to base dir "." folder
BASEDIR=`dirname "$0"`
echo "BASEDIR: $BASEDIR"

# Path to public project directory
PUBLIC_PROJECT_DIR="$BASEDIR/../axeptio-ios-sdk"
echo "PUBLIC_PROJECT_DIR: $PUBLIC_PROJECT_DIR"

# Get pod spec
PODSPEC="$PUBLIC_PROJECT_DIR/AxeptioSDK.podspec"
echo "PODSPEC: " $PODSPEC
if [ ! -f "$PODSPEC" ]; then
	echo "Pod spec $PODSPEC not found"
	exit 1
fi

echo "------------------------------------------------------------------"
echo "$SCRIPT_NAME Stage 3 - Framework new Version Checking"
echo

# Get version
VERSION=`cat "$PODSPEC" | awk '/s.version *=/{print $(NF)}'`
VERSION="${VERSION%\'}"
VERSION="${VERSION#\'}"

echo "installing VERSION: $VERSION"

# Ensure this is a new version
if [ "_`git tag -l $VERSION`" != "_" ]; then
	echo "Version $VERSION already delivered"
	exit 1
fi

echo "Will generate VERSION: $VERSION"

echo
echo "---------------------------------------------------------------------------"
echo "$SCRIPT_NAME  Stage 4 - Generating version $VERSION - Framework build preparation"
echo

# Build universal framework
WORKSPACE="$BASEDIR/AxeptioSDK.xcworkspace"
echo "WORKSPACE: $WORKSPACE"

TARGET=AxeptioSDK
CONFIGURATION=Release
ARCHIVES_DIR="$BASEDIR/Archives"
FRAMEWORKS_DIR="Products/Library/Frameworks"

echo "TARGET: $TARGET"
echo "CONFIGURATION: $CONFIGURATION"
echo "ARCHIVES_DIR: $ARCHIVES_DIR"
echo "FRAMEWORKS_DIR: $FRAMEWORKS_DIR"

echo
echo "---------------------------------------------------------------------------"
echo "$SCRIPT_NAME  Stage 5 - Checking version $VERSION exists in  $ARCHIVES_DIR"
echo

if [  -d "$ARCHIVES_DIR" ]; then
	echo "Archives Found at $ARCHIVES_DIR (Ok)"

	echo "---------------------------------------------------------------------------"
	echo "$SCRIPT_NAME  Stage 6 - Generating version $VERSION - Copying Framework to public AxeptioSDK "
	echo
	echo "ARCHIVES_DIR exists at : $ARCHIVES_DIR"
	echo "copy archive from: $ARCHIVES_DIR/$TARGET.xcframework"
	echo "to: $PUBLIC_PROJECT_DIR/AxeptioSDK"
	echo
	// cp -Rf "$ARCHIVES_DIR/$TARGET.xcframework" "$PUBLIC_PROJECT_DIR/AxeptioSDK"

    echo
    echo "---------------------------------------------------------------------------"
    echo "$SCRIPT_NAME  Stage 7- Generating version $VERSION - Clean Archives and Framework Folder at ARCHIVES_DIR"
    echo

    # Clean
    rm -rf "$ARCHIVES_DIR"
    
    echo
    echo "---------------------------------------------------------------------------"
    echo "$SCRIPT_NAME  Stage 8 - Generating version $VERSION - Commit and push Axeptio SDK to GitHub axeptio-ios-sdk"
    echo

    cd "$PUBLIC_PROJECT_DIR"
    git add ./*
    git commit -m "Release $VERSION"
    git tag $VERSION

    echo "---------------------------------------------------------------------------"
    echo "$SCRIPT_NAME  Stage 9 - Generating version $VERSION - Push Axeptio SDK to GitHub axeptio-ios-sdk"
    echo
    git push
    git push --tag

    echo "---------------------------------------------------------------------------"
    echo "$SCRIPT_NAME  Stage 10 - Generating version $VERSION - publishing on Cocoapods"
    echo
    cd -
    pod trunk lint "$PODSPEC" --allow-warnings --skip-tests

    echo "---------------------------------------------------------------------------"
    echo "$SCRIPT_NAME  Stage 11 - Generating version $VERSION - publishing on Cocoapods"
    echo
    cd -
    pod trunk push "$PODSPEC" --allow-warnings

else
	echo "---------------------------------------------------------------------------"
	echo "$SCRIPT_NAME  Stage 12"
	echo "No Existing Folder to delete at $ARCHIVES_DIR (Ok)"
	echo "=> you have to build Archives or check for issues"
fi



echo "---------------------------------------------------------------------------"
echo "$SCRIPT_NAME  12 -  INSTALL END - Installing version $VERSION in Local SDK at $PUBLIC_PROJECT_DIR/AxeptioSDK"
