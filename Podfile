# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def pods
    
    pod 'Material', ' 2.10.2', :inhibit_warnings => true
    pod 'SnapKit', '~> 4.0', :inhibit_warnings => true

end

target 'CodingChallenge' do
    pods
end

target 'CodingChallengeTests' do
    pods
end

target 'GitHub' do
    pods
end

post_install do |installer|
    
    swift3Targets = ['Material']
    installer.pods_project.targets.each do |target|
        
        # Configure 3.0 Pods
        if swift3Targets.include? target.name
            target.build_configurations.each do |configuration|
                configuration.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end

