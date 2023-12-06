# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'LAS_XMAS_002' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LAS_XMAS_002
pod 'Toast-Swift'
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SDWebImage'
  pod 'Alamofire'
  pod 'ReachabilitySwift'
  pod 'lottie-ios'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end

