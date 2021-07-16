#
# Be sure to run `pod lib lint LSBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LSBase'
  s.version          = '0.1.6'
  s.summary          = '基础组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
封装一些常用基础组件，如HudView、EmptyView、遵循mvvm的protocol
                       DESC

  s.homepage         = 'http://172.18.63.220/lanshan_ios/doc/lsbasis'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zrf' => 'zhourongfeng@021.com' }
  s.source           = { :git => 'http://172.18.63.220/lanshan_ios/doc/lsbasis/lsbase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'
  s.source_files = 'LSBase/Classes/**/*'
  s.resource = ['LSBase/Assets/*.{xcassets}']  #与主工程使用同一个命名空间，使用资源时避免命名冲突
#   s.resource_bundles = {
#     'LSBase' => ['LSBase/Assets/*.{xcassets}']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RxSwift', '~> 6.2.0'
  s.dependency 'SnapKit', '~> 5.0.1'
end
