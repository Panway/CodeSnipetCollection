Pod::Spec.new do |s|
  s.name             = 'PPiOSKit'
  s.version          = '0.0.1'
  s.summary          = 'Personal Tool of Panda'
  s.description      = <<-DESC
                      Enjoy it!
                       DESC

  s.homepage         = 'https://github.com/Panway/CodeSnipetCollection'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Panway' => 'upbeatpan@gmail.com' }
  s.source           = { :git => 'https://github.com/Panway/CodeSnipetCollection.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '4.2'
  s.ios.deployment_target = '8.0'

  #s.source_files = 'PPiOSKit/Classes/**/*'
  # s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'PPiOSKit/Classes/**/*'
    #core.exclude_files = 'SDWebImage/UIImage+WebP.{h,m}', 'SDWebImage/SDWebImageWebPCoder.{h,m}'
  end

  s.subspec 'PPAlertAction' do |ppalertaction|
    ppalertaction.ios.deployment_target = '8.0'
    ppalertaction.source_files = 'iOS/PPAlertAction/**/*'
  end

  s.subspec 'SwipePopGesture' do |ppalertaction|
    ppalertaction.ios.deployment_target = '8.0'
    ppalertaction.source_files = 'iOS/SwipePopGesture/**/*'
  end
  # s.resource_bundles = {
  #   'PWiOSTool' => ['PWiOSTool/Assets/*.png']
  # }
  s.requires_arc = true
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
