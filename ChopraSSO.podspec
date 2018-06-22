#
# Be sure to run `pod lib lint ChopraSSO.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ChopraSSO'
  s.version          = '1.1.1'
  s.summary          = 'ChopraSSO is the iOS library to use Chopra Login for your app'
  s.description      = <<-DESC
ChopraSSO is the iOS library to use Chopra Login for your app. Login or register with email, facebook, google.
                       DESC

  s.homepage         = 'https://account.chopra.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stylers' => 'tamas.szabo@stylersonline.com' }
  s.source           = { :git => 'git@github.com:stylers-llc/chopra-account-ios-sdk.git', :branch => 'develop', :tag => 'v1.1.1' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'ChopraSSO/Classes/**/*'
  
  s.resource_bundles = {
    'ChopraSSO' => ['ChopraSSO/Assets/*.png']
  }

  s.public_header_files = 'ChopraSSO/Classes/ChopraSSO.h', 'ChopraSSO/Classes/ChopraLoginViewController.h', 'ChopraSSO/Classes/ChopraAccount.h'
  s.frameworks = 'UIKit', 'Foundation'
  
  s.dependency 'FBSDKCoreKit', '<= 4.20'
  s.dependency 'FBSDKLoginKit', '<= 4.20'
  s.dependency 'GoogleSignIn', '<= 4.1.2'

end
