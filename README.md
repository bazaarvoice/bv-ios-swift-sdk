


# BVSwift – Bazaarvoice's Swift SDK
[![Version](https://img.shields.io/cocoapods/v/BVSwift.svg?style=flat)](https://cocoapods.org/pods/BVSwift)
[![License](https://img.shields.io/cocoapods/l/BVSwift.svg?style=flat)](https://cocoapods.org/pods/BVSwift)
[![Platform](https://img.shields.io/cocoapods/p/BVSwift.svg?style=flat)](https://cocoapods.org/pods/BVSwift)
## Introduction
BVSwift is currently in **α** stage of development, therefore, is a work in progress and everything is subject to change until it reaches **β** stage. If you can't find something here then it's probably best to first go to [the objc library](https://github.com/bazaarvoice/bv-ios-sdk) as well as check the [public documentation](https://developer.bazaarvoice.com/mobile-sdks/ios).
## Supported Modules
 - [BVAnalytics](https://github.com/bazaarvoice/BVSwift/tree/master/Sources/BVSwift/BVAnalytics)
 - [BVConversations](https://github.com/bazaarvoice/BVSwift/tree/master/Sources/BVSwift/BVConversations)
 - [BVCurations](https://github.com/bazaarvoice/BVSwift/tree/master/Sources/BVSwift/BVCurations)
 - [BVRecommendations](https://github.com/bazaarvoice/BVSwift/tree/master/Sources/BVSwift/BVRecommendations)
## How To Get Started
- Read [this](https://developer.bazaarvoice.com/mobile-sdks/ios/getting-started). Some of it will only be pertinent to the objc library but most of it is apropos.
- [Download BVSwift](https://github.com/bazaarvoice/BVSwift/archive/master.zip) and peruse the various examples (currently only tests).
## Communication
- If you **need help**, contact: support@bazaarvoice.com
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.
## Installation
BVSwift supports multiple methods for installing the library in a project. However, installation via CocoaPods is the currently preferred method.
## Installation with CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager that works with Xcode, which automates and simplifies the process of using 3rd-party libraries like BVSwift in your projects. You can install it with the following command:
```bash
$ gem install cocoapods
```
> CocoaPods 1.5+ is required to build BVSwift 0.1.0+.
#### Podfile
To integrate BVSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'BVSwift'
end
```
Then, run the following command:
```bash
$ pod install
```
## Manual Installation
1. Download the project
2. Build project via Xcode
3. Install built module into your Xcode project
## Configuration
 1. Via the [existing configuration file](https://developer.bazaarvoice.com/mobile-sdks/ios/getting-started/installation#configuring-the-bvsdk)
 2. Via directly interacting with the BVManager, for example: `BVManager.sharedManager.addConfiguration(configuration)`
 3. Via configuring objects directly _([example](https://github.com/bazaarvoice/BVSwift/tree/master/Sources/BVSwift/BVConversations))_

> The above configuration precedence is followed by the order in which they are discussed above, e.g., if you've configured via (1) but apply a configuration directly to the object (3) the SDK will use what was provided in (3). Also, **development configurations** take precedence if multiple configurations are found at the same level.
## Author
Bazaarvoice, support@bazaarvoice.com
## License
BVSwift is available under Commercial license. See the [LICENSE](https://github.com/bazaarvoice/BVSwift/blob/master/LICENSE) file for more info.
