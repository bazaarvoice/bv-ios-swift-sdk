xcodebuild clean build test  -project BVSwift.xcodeproj -scheme "BVSwift" -enableCodeCoverage YES -derivedDataPath Build/ -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11,OS=latest'
wget https://raw.githubusercontent.com/SonarSource/sonar-scanning-examples/master/swift-coverage/swift-coverage-example/xccov-to-sonarqube-generic.sh
bash xccov-to-sonarqube-generic.sh Build/Logs/Test/*.xcresult/ > sonarqube-generic-coverage.xml

#Change absolute paths to relative paths
sed -i '.bak' "s+$(pwd)+.+g" sonarqube-generic-coverage.xml
