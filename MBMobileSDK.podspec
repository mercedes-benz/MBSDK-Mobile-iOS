Pod::Spec.new do |s|
	s.name          = "MBMobileSDK"
	s.version       = "2.0.0"
    s.summary       = "MBMobileSDK"
    s.description   = "MBMobileSDK is a public Pod of MBition GmbH"
	s.homepage      = "https://mbition.io"
	s.license       = 'MIT'
	s.author        = { "MBition GmbH" => "info_mbition@daimler.com" }
	s.source        = { :git => "https://github.com/Daimler/MBSDK-Mobile-iOS.git", :tag => String(s.version) }
	s.platform      = :ios, '10.0'
	s.swift_version = ['5.0', '5.1', '5.2']

    s.source_files = 'MBMobileSDK/MBMobileSDK/**/*.{swift,xib}'
    s.resources = 'MBMobileSDK/MBMobileSDK/Resources/**/*.{xcassets,strings,storyboard,json,mp4,ttf}'

	# internal dependencies
	s.dependency 'MBCarKit', '~> 2.0'
	s.dependency 'MBCommonKit', '~> 2.0'
	s.dependency 'MBIngressKit', '~> 2.0'
	s.dependency 'MBNetworkKit', '~>2.0'
end
