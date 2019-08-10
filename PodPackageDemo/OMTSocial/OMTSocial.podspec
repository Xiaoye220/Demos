#
# Be sure to run `pod lib lint OMTSocial.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OMTSocial'
  s.version          = '0.0.1'
  s.summary          = 'A short description of OMTSocial.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Xiaoye220/OMTSocial'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Xiaoye220' => '576934532@qq.com' }
  s.source           = { :git => 'https://github.com/Xiaoye220/OMTSocial.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  # s.ios.vendored_frameworks = 'OMTSocialBase-0.0.1/ios/OMTSocialBase.framework'

  # s.dependency 'OMTFoundation'

  s.subspec 'Core' do |sp|
    sp.ios.vendored_frameworks = 'OMTSocial-' + s.version.to_s + '/ios/OMTSocial.framework'
  end

  s.subspec 'Facebook' do |sp|
     sp.ios.vendored_frameworks = 'OMTSocialFacebook-' + s.version.to_s + '/ios/OMTSocialFacebook.framework'

     sp.dependency 'OMTSocial/Core'
  end

  # s.subspec 'Twitter' do |sp|
  #    # sp.source_files = 'OMTSocial/Classes/Twitter/*'
  #    sp.ios.vendored_frameworks = 'OMTSocialTwitter-0.0.1/ios/OMTSocialTwitter.framework'

  #    sp.dependency 'OMTSocial/Base'
  # end


  # s.resource_bundles = {
  #   'OMTSocial' => ['OMTSocial/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

end
