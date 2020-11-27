source 'https://github.com/CocoaPods/Specs.git'

platform :ios,'12.0'
use_frameworks!
inhibit_all_warnings!
workspace 'MBMobileSDK'


def appPods
	# code analyser
	pod 'SwiftGen', '~> 6.0'
	pod 'SwiftLint', '~> 0.30'

	# data
	pod 'SwiftProtobuf', '~> 1.0'

	# zip file handling
	pod 'ZIPFoundation', '~> 0.9'

	pod 'SwiftKeychainWrapper', '~> 4.0'
	
	# module
	pod 'MBCommonKit', '~> 3.0'
	pod 'MBNetworkKit', '~> 3.0'
	pod 'MBRealmKit', '~> 3.0'
end


target 'Example' do
	project 'Example/Example'
	
	appPods
end

target 'MBMobileSDK' do
	project 'MBMobileSDK/MBMobileSDK'
	
	appPods

	target 'MBMobileSDKTests' do
		pod 'OHHTTPStubs/Swift', '~> 9.0'
    	pod 'Quick', '~> 2.0'
    	pod 'Nimble', '~> 8.0'
	end
end                                                 


post_install do |installer|

	# delete deployment target warning
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
		end
	end
end
