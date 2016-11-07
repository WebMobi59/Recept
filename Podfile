# Uncomment this line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

link_with 'Recept-Debug', 'Recept-Dev', 'Recept-Test', 'Recept-Production', 'Recept-Release', 'Recept-UnitTests', 'ReceptTests'

pod 'Google/Analytics'
pod 'SSZipArchive', '~> 0.3.2'
pod 'AFNetworking', '~> 2.5'
pod 'MMDrawerController', '~> 0.5.7'
pod 'SVGKit', :git => 'https://github.com/SVGKit/SVGKit.git', :branch => '2.x'
# pod 'EmitterKit', '~> 4.0.1' ... Added as Vendor manuallyemitter-kit-4.0.1 since it's written in Swift and we're on deployment target iOS7 that cannot have !use_frameworks

post_install do |installer|
    puts "\nPost configuring ...['ENABLE_BITCODE'] = 'NO'...['ONLY_ACTIVE_ARCH'] = 'NO'..."
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end