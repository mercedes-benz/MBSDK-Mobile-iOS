Pod::Spec.new do |s|
	s.name          = "MBMobileSDK"
	s.version       = "3.0.0"
    s.summary       = "MBMobileSDK"
    s.description   = "MBMobileSDK is a public Pod of MBition GmbH"
	s.homepage      = "https://mbition.io"
	s.license       = 'MIT'
	s.author        = { "MBition GmbH" => "info_mbition@daimler.com" }
	s.source        = { :git => "https://github.com/Daimler/MBSDK-Mobile-iOS.git", :tag => String(s.version) }
	s.platform      = :ios, '12.0'
	s.swift_version = ['5.0', '5.1', '5.2', '5.3']

    s.source_files = 'MBMobileSDK/MBMobileSDK/**/*.{swift,xib}'

    # internal dependencies
    s.dependency 'MBCommonKit', '~> 3.0'
    s.dependency 'MBNetworkKit', '~> 3.0'
    s.dependency 'MBRealmKit', '~> 3.0'

    # public dependencies
    s.dependency 'SwiftKeychainWrapper', '~> 4.0'
    s.dependency 'SwiftProtobuf', '~> 1.0'
    s.dependency 'ZIPFoundation', '~> 0.9'

    # fix for RLMNotificationToken
    s.dependency 'Realm', '~> 10.1'
end
