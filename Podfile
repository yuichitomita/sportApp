source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'sportApp' do
pod 'DrawerController'
pod 'HaishinKit'
pod 'PagingMenuController'
pod 'SwiftyJSON'
pod 'SnapKit', '~> 4.0'
pod 'FacebookLogin'
pod 'FacebookCore'
pod 'Alamofire', '~> 4.0'
pod 'Socket.IO-Client-Swift'
pod 'JSQMessagesViewController', :git => 'https://github.com/jessesquires/JSQMessagesViewController.git', :branch => 'develop'
end









post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['SWIFT_VERSION'] = "4.0"
    end
  end
end
