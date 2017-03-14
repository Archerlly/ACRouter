#
# Be sure to run `pod lib lint ACRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ACRouter'
  s.version          = '0.1.0'
  s.summary          = 'A simple router for swift'
  s.homepage         = 'https://github.com/Archerlly/ACRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Archerlly' => '2302693080@qq.com' }
  s.source           = { :git => 'https://github.com/Archerlly/ACRouter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'ACRouter/Classes/**/*'
  s.requires_arc = true

end
