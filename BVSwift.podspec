#
# Be sure to run `pod lib lint BSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name              = 'BVSwift'
  s.version           = '0.1.2'
  s.summary           = 'Simple Swift based iOS SDK to interact with the Bazaarvoice platform API.'
  s.description       = 'The Bazaarvoice Software Development Kit (SDK) is a Swift iOS library that provides an easy way to generate REST calls to the Bazaarvoice Developer API. Using this SDK, mobile developers can quickly integrate Bazaarvoice content into their native iOS apps for iPhone and iPad on iOS 8.0 or newer.'

  s.homepage          = 'https://github.com/bazaarvoice/BVSwift'
  s.license           = { :type => 'Commercial', :text => 'See https://developer.bazaarvoice.com/API_Terms_of_Use' }
  s.author            = { 'Bazaarvoice' => 'support@bazaarvoice.com' }
  s.source            = { :git => "https://github.com/bazaarvoice/BVSwift.git", :tag => s.version.to_s }
  s.social_media_url  = 'https://twitter.com/bazaarvoice'

  s.ios.deployment_target = '8.0'
  s.platform = :ios, '8.0'
  s.swift_version = '4.0'
  s.default_subspec = 'BVCommon'

  s.subspec 'BVCommon' do |common|
   common.source_files = 'Sources/BVSwift/BVCommon/**/*.swift'
  end

  s.subspec 'BVAnalytics' do |analytics|
    analytics.source_files = 'Sources/BVSwift/BVAnalytics/**/*.swift'
    analytics.dependency 'BVSwift/BVCommon'
  end

  s.subspec 'BVConversations' do |conversations|
    conversations.source_files = 'Sources/BVSwift/BVConversations/**/*.swift'
    conversations.dependency 'BVSwift/BVCommon'
    conversations.dependency 'BVSwift/BVAnalytics'
  end

  s.subspec 'BVCurations' do |curations|
    curations.source_files = 'Sources/BVSwift/BVCurations/**/*.swift'
    curations.dependency 'BVSwift/BVCommon'
    curations.dependency 'BVSwift/BVAnalytics'
  end

  s.subspec 'BVRecommendations' do |recommendations|
    recommendations.source_files = 'Sources/BVSwift/BVRecommendations/**/*.swift'
    recommendations.dependency 'BVSwift/BVCommon'
    recommendations.dependency 'BVSwift/BVAnalytics'
  end
end
