Pod::Spec.new do |s|
  s.name          = "MBMobileSDK"
  s.version       = "1.0.1"
  s.summary       = "MBMobileSDK" 
  s.description   = "MBMobileSDK is a public Pod of MBition GmbH"
  s.homepage      = "https://mbition.io"
  s.license       = 'MIT'
  s.author        = { "MBition GmbH" => "info_mbition@daimler.com" }
  s.source        = { :git => "https://github.com/Daimler/MBSDK-Mobile-iOS.git", :tag => String(s.version) }
  s.platform      = :ios, '10.0'
  s.requires_arc  = true
  s.swift_version = ['4.2', '5.0']

  s.public_header_files = 'MBMobileSDK/MBMobileSDK.framework/Headers/*.h'
  s.source_files = 'MBMobileSDK/MBMobileSDK.framework/Headers/*.h'
  s.vendored_frameworks = "MBMobileSDK/MBMobileSDK.framework"

  # external dependencies
  s.dependency 'JumioMobileSDK/Netverify', '~> 3.0'
  s.dependency 'KeychainAccess', '~> 3.1'
  s.dependency 'LaunchDarkly', '~> 3.0'
  s.dependency 'YandexMobileMetrica/Dynamic', '~> 3.0'

  # internal dependencies
  s.dependency 'MBCommonKit', '~> 1.0'
  s.dependency 'MBDeeplinkKit', '~> 1.0'
  s.dependency 'MBIngressKit', '~> 1.0'
  s.dependency 'MBCarKit', '~> 1.0'
  s.dependency 'MBNetworkKit', '~> 1.0'
  s.dependency 'MBRealmKit/UI', '~> 1.0'
  s.dependency 'MBSupportKit', '~> 1.0'
  s.dependency 'MBUIKit', '~> 1.0'

  # pod target configuration
  s.pod_target_xcconfig = {
    "OTHER_LDFLAGS" => '$(inherited) -framework JumioCore -framework MicroBlink -framework Netverify -framework NetverifyBarcode -framework NetverifyFace -framework ZoomAuthenticationHybrid',
    "FRAMEWORK_SEARCH_PATHS" => '$(inherited) "${PODS_ROOT}/Pods/JumioMobileSDK/**"',
    "VALID_ARCHS" => 'x86_64 armv7 armv7s arm64 arm64e'
  }
end
