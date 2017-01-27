#
# Be sure to run `pod lib lint ChopraSSO.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ChopraSSO'
  s.version          = ‘1.0.0’
  s.summary          = 'ChopraSSO is the iOS library to use Chopra Login for your app'
  s.description      = <<-DESC
ChopraSSO is the iOS library to use Chopra Login for your app. Login or register with email, facebook, google.
                       DESC

  s.homepage         = 'https://account.chopra.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Stylers' => 'tamas.szabo@stylersonline.com' }
  s.source           = { :git => 'ssh://ors-kovacs@visszaszamolas.hu/var/git_staging/ios/deepak045_sso_sdk/', :branch => swift-3, :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ChopraSSO/Classes/**/*'
  
  s.resource_bundles = {
    'ChopraSSO' => ['ChopraSSO/Assets/*.png']
  }

  s.public_header_files = 'ChopraSSO/Classes/ChopraSSO.h', 'ChopraSSO/Classes/ChopraLoginViewController.h', 'ChopraSSO/Classes/ChopraAccount.h'
  s.frameworks = 'UIKit', 'Foundation'
end
