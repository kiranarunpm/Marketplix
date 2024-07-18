# Uncomment the next line to define a global platform for your project
# platform :ios, '16.0'

target 'Marketplix' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'GoogleMaps'
  pod 'IQKeyboardManagerSwift'
  pod 'SideMenu', '~> 6.5'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod "ImageSlideshow/Kingfisher"
  pod 'ReadMoreTextView', '~> 3.0'
  pod 'Alamofire'
  pod 'SkeletonView', '~> 1.30'
  pod "ImageSlideshow/Kingfisher"
  pod 'DatePickerDialog'
  pod 'BSImagePicker'
  pod 'Hero'
  pod 'Firebase', '~> 10.16'
  pod 'FirebaseMessaging'
  pod 'CircleProgressBar', '~> 0.32'
  pod 'DropDown'
  target 'MarketplixTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MarketplixUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
        end
      end
    end
  end


end


 
