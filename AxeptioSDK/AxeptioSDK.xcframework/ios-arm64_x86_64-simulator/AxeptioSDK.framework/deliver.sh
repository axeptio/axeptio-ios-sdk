#!/bin/bash

echo
echo "------------------------------------------------------------------"
echo "START"
echo

XCODE="Xcode_12.5.app"
echo
echo "------------------------------------------------------------------"
echo "Stage 1 - Checking required Xcode version : $XCODE"
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
echo "Stage 2 - Cocoapods Pods Checking"
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
echo "Stage 3 - Framework new Version Checking"
echo

# Get version
VERSION=`cat "$PODSPEC" | awk '/s.version *=/{print $(NF)}'`
VERSION="${VERSION%\'}"
VERSION="${VERSION#\'}"

echo "Should Generate VERSION: $VERSION"

# Ensure this is a new version
if [ "_`git tag -l $VERSION`" != "_" ]; then
	echo "Version $VERSION already delivered"
	exit 1
fi

echo "Will generate VERSION: $VERSION"

echo
echo "---------------------------------------------------------------------------"
echo "Stage 4 - Generating version $VERSION - Framework build preparation"
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
echo "Stage 4 - Generating version $VERSION - Delete previous Archive $ARCHIVES_DIR"
echo

if [  -d "$ARCHIVES_DIR" ]; then
	echo "delete Archive folder at $ARCHIVES_DIR (Ok)"
	rm -rf "$ARCHIVES_DIR"
else
	echo "No Existing Folder to delete at $ARCHIVES_DIR (Ok)"
fi

echo
echo "---------------------------------------------------------------------------"
echo "Stage 5 - Generating version $VERSION - Prepare SDK targets"
echo

iPhone_SDK="iphoneos"
iPhoneSim_SDK="iphonesimulator"
tvOS_SDK="appletvos"
tvOSSim_SDK="appletvsimulator"
watchOS_SDK="watchos"
watchOSSim_SDK="watchsimulator"
macOS_SDK="-macosx"

echo
echo "---------------------------------------------------------------------------"
echo "Stage 5 - Generating version $VERSION - Build $iPhone_SDK"
echo

xcodebuild archive -workspace "$WORKSPACE" \
	-scheme "$TARGET" \
	-configuration "$CONFIGURATION" \
	-sdk "$iPhone_SDK" \
	-archivePath "$ARCHIVES_DIR/ios_devices.xcarchive" \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	SKIP_INSTALL=NO

echo
echo "---------------------------------------------------------------------------"
echo "Stage 6 - Generating version $VERSION - Build $iPhoneSim_SDK"
echo

xcodebuild archive -workspace "$WORKSPACE" \
	-scheme "$TARGET" \
	-configuration "$CONFIGURATION" \
	-sdk "$iPhoneSim_SDK" \
	-archivePath "$ARCHIVES_DIR/ios_simulators.xcarchive" \
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	SKIP_INSTALL=NO

	if [  -d "$ARCHIVES_DIR" ]; then
		echo
		echo "---------------------------------------------------------------------------"
		echo "Stage 7.0 - Generating version $VERSION - Framework Generation From SDK Target Archives"
		echo
		xcodebuild -create-xcframework \
			-framework "$ARCHIVES_DIR/ios_devices.xcarchive/$FRAMEWORKS_DIR/$TARGET.framework" \
			-framework "$ARCHIVES_DIR/ios_simulators.xcarchive/$FRAMEWORKS_DIR/$TARGET.framework" \
			-output "$ARCHIVES_DIR/$TARGET.xcframework"
		echo
		echo "---------------------------------------------------------------------------"
		echo "Stage 7.1 - Generating version $VERSION - Copying Framework to public AxeptioSDK "
		echo
		echo "ARCHIVES_DIR exists at : $ARCHIVES_DIR"
		echo "copy archive from: $ARCHIVES_DIR/$TARGET.xcframework"
		echo "to: $PUBLIC_PROJECT_DIR/AxeptioSDK"
		echo
		cp -Rf "$ARCHIVES_DIR/$TARGET.xcframework" "$PUBLIC_PROJECT_DIR/AxeptioSDK"

		echo
		echo "---------------------------------------------------------------------------"
		echo "Stage 7.2 - Generating version $VERSION - Clean Archives and Framework Folder at ARCHIVES_DIR"
		echo

		# Clean
		rm -rf "$ARCHIVES_DIR"
		echo
		echo "---------------------------------------------------------------------------"
		echo "Stage 7.3 - Generating version $VERSION - Commit and push Axeptio SDK to GitHub axeptio-ios-sdk"
		echo

		cd "$PUBLIC_PROJECT_DIR"
		git add ./*
		git commit -m "Release $VERSION"
		git tag $VERSION

		echo "---------------------------------------------------------------------------"
		echo "Stage 7.3 - Generating version $VERSION - Push Axeptio SDK to GitHub axeptio-ios-sdk"
		echo
		git push
		git push --tag

		echo "---------------------------------------------------------------------------"
		echo "Stage 7.4 - Generating version $VERSION - publishing on Cocoapods"
		echo
		cd -
		pod trunk push "$PODSPEC" --allow-warnings

	else
		echo "---------------------------------------------------------------------------"
		echo "Stage 8 - Build Fails Generating version $VERSION : cannot generate one or more SDK targets Archives at $ArchiveDir"
	fi

	echo "---------------------------------------------------------------------------"
	echo "Stage 9 - END -Generating version $VERSION"
