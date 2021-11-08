# Uncomment the next line to define a global platform for your project
use_frameworks!
workspace 'mylost'

def components_pods
	pod 'SDWebImage'
	pod 'MaterialComponents/TextControls+FilledTextAreas'
	pod 'MaterialComponents/TextControls+FilledTextFields'
	pod 'MaterialComponents/TextControls+OutlinedTextAreas'
	pod 'MaterialComponents/TextControls+OutlinedTextFields'
	pod 'MaterialComponents/ActivityIndicator'
	pod 'MaterialComponents/Chips'
end

target 'Components' do
	project 'Components/Components.project'
	components_pods
end

def core_pods
	pod 'Swinject'
	pod 'RxSwift', '6.2.0'
   	pod 'RxCocoa', '6.2.0'
end

target 'Core' do
	project 'Core/Core.project'
	core_pods
end

def application_pods
	core_pods
	components_pods
   	pod 'RxDataSources'
  	
	pod 'SwiftLint'
	pod 'LifetimeTracker'
	
	pod 'IQKeyboardManagerSwift'
	pod 'MessageKit'
end

target 'mylost' do
	project 'mylost.project'
	application_pods
    
end
