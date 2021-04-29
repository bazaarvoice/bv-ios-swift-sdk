#!/bin/bash

cd "$(dirname "$0")"

cleanup() {
	kill -9 $pid
}
control_c()
# run if user hits control-c
{
	echo 'exiting...'
	cleanup
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT


echo "Starting run_tests script"
set -euf -o pipefail



./print_time.sh &
pid=$!
echo "my pid: $pid"

echo Starting build of BVSwiftDemo...
set -euf -o pipefail

echo Installing cocoapods dependencies for the BVSwiftDemo...
cd ../Examples/BVSwiftDemo
pod install
cd ../..


echo Staring build...
xcodebuild ONLY_ACTIVE_ARCH=YES -workspace ./Examples/BVSwiftDemo/BVSwiftDemo.xcworkspace -scheme "Staging" -sdk iphonesimulator -UseModernBuildSystem=NO | xcpretty -c

cleanup
