platform :ios,'10.0'
use_frameworks!
inhibit_all_warnings!
workspace 'MBMobileSDK'


def appPods
	# code analyser
	pod 'SwiftGen', '~> 6.0'
	pod 'SwiftLint', '~> 0.30'
	
	# module
	pod 'MBCarKit', '~> 2.0'
	pod 'MBCommonKit', '~> 2.0'
	pod 'MBIngressKit', '~> 2.0'
	pod 'MBNetworkKit', '~> 2.0'
end


target 'Example' do
	project 'Example/Example'
	
	appPods
end

target 'MBMobileSDK' do
	project 'MBMobileSDK/MBMobileSDK'
	
	appPods

	target 'MBMobileSDKTests' do
	end
end                                                 


post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['SWIFT_VERSION'] = '5.0'
		end
	end
end
