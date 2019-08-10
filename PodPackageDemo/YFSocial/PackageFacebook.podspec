Pod::Spec.new do |s|
  s.name             = 'YFSocialFacebook'
  s.version          = '0.0.1'
  s.summary          = 'A short description of YFSocial.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Xiaoye220/YFSocial'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Xiaoye220' => '576934532@qq.com' }
  s.source           = { :git => '/Users/YZF/Desktop/CocoaPodsTest/YFSocial'}

  s.ios.deployment_target = '7.0'

  s.subspec 'Facebook' do |sp|
     sp.source_files = 'YFSocial/Classes/Facebook/*'
     sp.ios.vendored_frameworks = 'YFSocial-0.0.1/ios/YFSocial.framework'
     # sp.dependency 'YFSocial/Core'
  end

end