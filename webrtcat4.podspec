#
# Be sure to run `pod lib lint webrtcat4.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'webrtcat4'
  s.version          = '4.0.0'
  s.summary          = 'WebRTCat 4 iOS client.'

  s.description      = <<-DESC
This project contains the WebRTCat4 client library for iOS as well as an example application using the client.
                       DESC

  s.homepage         = 'https://github.com/seg-i2CAT/webrtcat4_ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'i2CAT' => 'develop@i2cat.net' }
  s.source           = { :git => 'https://github.com/seg-i2CAT/webrtcat4_ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'webrtcat4/Classes/**/*'

  s.public_header_files = 'webrtcat4/Classes/**/*.h'
  s.dependency 'SocketRocket'
  s.dependency 'GoogleWebRTC'
  
end
