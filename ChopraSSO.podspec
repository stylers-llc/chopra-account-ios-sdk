#
# Be sure to run `pod lib lint ChopraSSO.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ChopraSSO'
  s.version          = '2.0.0'
  s.summary          = 'A short description of ChopraSSO.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/encosw/ChopraSSO'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'encosw' => 'kovacs.ors@encosoft.hu' }
  s.source           = { :git => 'https://github.com/encosw/ChopraSSO.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ChopraSSO/Classes/**/*.swift'
  
  s.resource_bundles = {
    'ChopraSSO' => ['ChopraSSO/Assets/*.png']
  }

#s.public_header_files = 'ChopraSSO/Classes/ChopraSSO.swift', 'ChopraSSO/Classes/ChopraLoginViewController.swift', 'ChopraSSO/Classes/ChopraAccount.swift'
    s.frameworks = 'UIKit', 'Foundation'
    s.static_framework = true

    s.dependency 'FBSDKCoreKit', '<= 4.34.0'
    s.dependency 'FBSDKLoginKit', '<= 4.34.0'
    s.dependency 'GoogleSignIn', '<= 4.1.2'
    s.dependency 'CryptoSwift', '<= 0.8.3'
    s.dependency 'SwiftyJSON', '<= 4.1'

end
