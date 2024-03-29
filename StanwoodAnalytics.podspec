Pod::Spec.new do |s|
  s.name             = 'StanwoodAnalytics'
  s.version          = '1.2.0'
  s.swift_version   = '5.0'
  s.summary          = 'StanwoodAnalytics encapsulates the frameworks Stanwood uses from various vendors used in analytics and logging.'
  s.description      = <<-DESC
A framework to encapsulate analytics and logging frameworks from Crashlytics, Google, and Firebase.
                       DESC

  s.homepage         = 'https://github.com/stanwood/Stanwood_Analytics_iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'stanwood' => 'ios.frameworks@stanwood.io' }
  s.source           = { :git => 'https://github.com/stanwood/Stanwood_Analytics_iOS.git', :tag => s.version.to_s}
  
  s.ios.deployment_target = '13.3'
  s.static_framework = true
  s.default_subspec = 'Base'

  s.pod_target_xcconfig = {
      'OTHER_LDFLAGS' => '-ObjC',
      'FRAMEWORK_SEARCH_PATHS' => '$(inherited)'
  }
  
  s.libraries = [
  'c++',
  'sqlite3',
  'z',
  ]
  
  s.resource = 'StanwoodAnalytics/Assets/StanwoodAnalytics.bundle'
  
  s.frameworks = 'UserNotifications'
  
  s.subspec 'Core' do |ss|
      ss.source_files = 'StanwoodAnalytics/Classes/Core/'
  end
  
  s.subspec 'Base' do |ss|
      ss.dependency 'StanwoodAnalytics/Core'
      ss.dependency 'StanwoodAnalytics/Crashlytics'
      ss.dependency 'StanwoodAnalytics/Firebase'
      ss.dependency 'StanwoodAnalytics/TestFairy'
  end
  
  s.subspec 'Firebase' do |ss|
      ss.dependency 'StanwoodAnalytics/Core'
      ss.dependency 'Firebase/Analytics'
      ss.source_files = 'StanwoodAnalytics/Classes/SubSpecs/Firebase/'
      ss.frameworks = ['FirebaseCore',
      'FirebaseAnalytics',
      'FirebaseCoreDiagnostics']
  end
  
  s.subspec 'Crashlytics' do |ss|
      ss.dependency 'Firebase/Crashlytics'
      ss.dependency 'Firebase/Analytics'
      ss.dependency 'StanwoodAnalytics/Core'
      ss.source_files = 'StanwoodAnalytics/Classes/SubSpecs/Crashlytics/'
      ss.frameworks = ['FirebaseCore',
      'FirebaseAnalytics',
      'FirebaseCrashlytics',
      'FirebaseCoreDiagnostics']
  end
  
#  s.subspec 'BugFender' do |ss|
#      ss.dependency 'BugfenderSDK', '1.8'
#      ss.dependency 'StanwoodAnalytics/Core'
#      ss.source_files = 'StanwoodAnalytics/Classes/SubSpecs/BugFender/'
#  end
  
  s.subspec 'TestFairy' do |ss|
      ss.ios.vendored_library = 'Frameworks/libTestFairy.a'
      ss.dependency 'StanwoodAnalytics/Core'
      ss.source_files = 'StanwoodAnalytics/Classes/SubSpecs/TestFairy/*.{swift,h,m}'
      ss.frameworks = [
      'CoreMedia',
      'CoreMotion',
      'AVFoundation',
      'SystemConfiguration',
      'OpenGLES'
      ]
  end
  
  s.subspec 'Mixpanel' do |ss|
      ss.dependency 'Mixpanel-swift'
      ss.dependency 'StanwoodAnalytics/Core'
      ss.source_files = 'StanwoodAnalytics/Classes/SubSpecs/Mixpanel/'
  end
  
  #s.subspec 'Adjust' do |ss|
  #    ss.dependency 'Adjust', '~> 4.8.5'
  #end
  
  s.subspec 'Google' do |ss|
      ss.dependency 'StanwoodAnalytics/Core'
      ss.vendored_library = [
      'StanwoodAnalytics/Frameworks/GoogleAnalytics-3.17.0/Libraries/libGoogleAnalytics.a'
      ]
      ss.source_files =  'StanwoodAnalytics/Frameworks/GoogleAnalytics-3.17.0/Sources/*.h', 'StanwoodAnalytics/Classes/SubSpecs/GoogleAnalytics/'

      ss.frameworks = [
      'CoreData',
      'SystemConfiguration'
      ]
      ss.libraries = ['z', 'sqlite3']
  end
  
end
