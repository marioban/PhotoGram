# Specify the platform and version for your project
platform :ios, '17.0'

def shared_pods
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'Firebase/Storage'
  pod 'GoogleSignIn'
  pod 'Kingfisher'
  pod 'RealmSwift'##, '~> 10.39.1'
  pod 'Firebase/Analytics'
  pod 'Firebase/Performance'

end

target 'Instagram' do
  use_frameworks!
  shared_pods
end

target 'InstagramUITests' do
  use_frameworks!
  shared_pods
end

target 'InstagramUnitTests' do
  use_frameworks!
  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
      
      # Fix for BoringSSL-GRPC issues on iOS 17
      if target.name == 'BoringSSL-GRPC'
        config.build_settings['OTHER_CFLAGS'] ||= '$(inherited)'
        config.build_settings['OTHER_CFLAGS'] = config.build_settings['OTHER_CFLAGS'].sub('-G', '')
      end
    end
  end
end
