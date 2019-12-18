#!/bin/sh

OUTROOT=`pwd`/build/app/outputs/ios
echo $OUTROOT
flutter build ios --release
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -archivePath ${OUTROOT}/Runner.xcarchive -configuration Release -UseModernBuildSystem=NO clean archive
xcodebuild -allowProvisioningUpdates -exportArchive -archivePath ${OUTROOT}/Runner.xcarchive -exportOptionsPlist ExportOptions.plist -exportPath ${OUTROOT}/Runner.ipa/
