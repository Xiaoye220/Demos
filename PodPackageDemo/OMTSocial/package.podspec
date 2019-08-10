#
# Be sure to run `pod lib lint OMTSocial.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  # 从 ENV['subspec'] 获取当前要打包的 subspec 的 name
  subspec_name = ENV['subspec'].to_s
  # 根据 subspec_name 的不同生成不同的 s.name
  s_name = subspec_name == 'Core' ? 'OMTSocial' : 'OMTSocial' + subspec_name

  s.name             = s_name
  s.version          = '0.0.1'
  s.summary          = 'A short description of OMTSocial.'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Xiaoye220/OMTSocial'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Xiaoye220' => '576934532@qq.com' }
  s.source           = { :git => '/Users/YZF/Desktop/CocoaPodsTest/OMTSocial'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.subspec 'Core' do |sp|
    # 打包 Core 使用源码，打包其他 subspec 使用 framework
    if subspec_name == 'Core'
      sp.source_files = 'OMTSocial/Classes/*', 'OMTSocial/Classes/Core/*'
    else
      sp.ios.vendored_frameworks = 'OMTSocial-' + s.version.to_s + '/ios/OMTSocial.framework'
    end
  end

  s.subspec 'Facebook' do |sp|
    sp.source_files = 'OMTSocial/Classes/Facebook/*'
    sp.dependency "#{s.name}/Core"
  end

  # s.resource_bundles = {
  #   'OMTSocial' => ['OMTSocial/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'


end

