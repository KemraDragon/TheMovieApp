# Uncomment the next line to define a global platform for your project
 platform :ios, '12.2'

target 'TheMovieApp' do
  use_frameworks!

  pod 'RxSwift', '~> 5.1.1'
  pod 'RxCocoa', '~> 5.1.1'
  pod 'Alamofire', '~> 5.4.4'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.2'
      end
    end
  end