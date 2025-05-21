# Uncomment the next line to define a global platform for your project
platform :ios, '17.0'

source 'https://github.com/CocoaPods/Specs.git'

target 'Where_Are_You' do
  use_frameworks!

	pod 'Alamofire', '~> 5.6'
	pod 'SwiftLint'
	pod 'SnapKit', '~> 5.0'
	pod 'Moya', '~> 15.0'
	pod 'KakaoSDKCommon'
	pod 'KakaoSDKAuth'
	pod 'KakaoSDKUser'
	pod 'KakaoSDKShare'
	pod 'KakaoMapsSDK'
	pod 'Kingfisher', '~> 7.0'
	pod 'FirebaseAnalytics'
	pod 'Firebase/Messaging'
	pod 'IQKeyboardManager'
	pod 'FloatingPanel'
	pod 'Toast-Swift', '~> 5.1.1'

	target 'Where_Are_You_Tests' do
	  inherit! :search_paths
	end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Kakao 관련 Pods는 Deployment Target 변경하지 않음
      if target.name.start_with?('KakaoSDK')
        next
      end

      # Alamofire의 Deployment Target은 13.0으로 설정
      if target.name == 'Alamofire'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      else
        # 나머지 Pods의 Deployment Target은 17.0으로 설정
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
      end
    end
  end
end

