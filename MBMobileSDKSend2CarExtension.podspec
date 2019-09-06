Pod::Spec.new do |s|
  s.name          = "MBMobileSDKSend2CarExtension"
  s.version       = "1.0.0"
  s.summary       = "MBMobileSDK Share-Extension" 
  s.description   = "MBMobileSDK Share-Extenion is a public Pod of MBition GmbH"
  s.homepage      = "https://mbition.io"
  s.license       = 'MIT'
  s.author        = { "MBition GmbH" => "info_mbition@daimler.com" }
  s.source        = { :git => "https://github.com/Daimler/MBSDK-Mobile-iOS.git", :tag => String(s.version) }
  s.platform      = :ios, '10.0'
  s.requires_arc  = true
  s.swift_version = ['4.2', '5.0']

  s.public_header_files = 'MBMobileSDK/MBMobileSDKSend2CarExtension.framework/Headers/*.h'
  s.source_files = 'MBMobileSDK/MBMobileSDKSend2CarExtension.framework/Headers/*.h'
  s.vendored_frameworks = "MBMobileSDK/MBMobileSDKSend2CarExtension.framework"

  # internal dependencies
  s.dependency 'MBCommonKit', '~> 1.0'
  s.dependency 'MBIngressKit', '~> 1.0'
  s.dependency 'MBCarKit', '~> 1.0'
end
