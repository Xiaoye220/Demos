#
# Be sure to run `pod lib lint YFSocial.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YFSocial'
  s.version          = '0.0.1'
  s.summary          = 'A short description of YFSocial.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Xiaoye220/YFSocial'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Xiaoye220' => '576934532@qq.com' }
  s.source           = { :git => 'https://github.com/Xiaoye220/YFSocial.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  # s.ios.vendored_frameworks = 'YFSocialBase-0.0.1/ios/YFSocialBase.framework'

  # s.dependency 'YFFoundation'

  s.subspec 'Core' do |sp|
    if ENV['lib']
      sp.ios.vendored_frameworks = 'YFSocial-' + s.version.to_s + '/ios/YFSocial.framework'
    
    else
      sp.source_files = 'YFSocial/Classes/*', 'YFSocial/Classes/Core/*'

    end
  end

  s.subspec 'Facebook' do |sp|
    if ENV['lib']
      sp.ios.vendored_frameworks = 'YFSocialFacebook-' + s.version.to_s + '/ios/YFSocialFacebook.framework'
    
    else
      sp.source_files = 'YFSocial/Classes/Facebook/*'

    end

     sp.dependency 'YFSocial/Core'
  end

  # s.subspec 'Twitter' do |sp|
  #    # sp.source_files = 'YFSocial/Classes/Twitter/*'
  #    sp.ios.vendored_frameworks = 'YFSocialTwitter-0.0.1/ios/YFSocialTwitter.framework'

  #    sp.dependency 'YFSocial/Base'
  # end


  # s.resource_bundles = {
  #   'YFSocial' => ['YFSocial/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

end
