echo Starting run_tests script
set -euf -o pipefail

echo Building universal framework
xcodebuild -project BVSwift.xcodeproj -scheme BVSwift-Universal -configuration Release clean build -UseModernBuildSystem=NO | xcpretty -c

echo zipping framework...
ditto -ck --rsrc --sequesterRsrc --keepParent ./Output/BVSwift-Release-iphoneuniversal/BVSwift.framework BVSwift.framework.zip

echo validating zipped up framework
./ci_scripts/validate_zips.sh ./BVSwift.framework.zip
