Pod::Spec.new do |s|
  s.name             = 'OMTSocialFacebook'
  s.version          = '0.0.1'
  s.summary          = 'A short description of OMTSocial.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Xiaoye220/OMTSocial'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Xiaoye220' => '576934532@qq.com' }
  s.source           = { :git => '/Users/YZF/Desktop/CocoaPodsTest/OMTSocial'}

  s.ios.deployment_target = '7.0'

  s.subspec 'Facebook' do |sp|
     sp.source_files = 'OMTSocial/Classes/Facebook/*'
     sp.ios.vendored_frameworks = 'OMTSocial-0.0.1/ios/OMTSocial.framework'
     # sp.dependency 'OMTSocial/Core'
  end

end