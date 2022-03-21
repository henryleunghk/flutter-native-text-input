#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_native_text_input'
  s.version          = '2.2.0'
  s.summary          = 'Native text input for Flutter'
  s.description      = <<-DESC
  Native text input for Flutter
                       DESC
  s.homepage         = 'https://github.com/henryleunghk/flutter-native-text-input'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Henry Leung' => 'hk.eleven@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '9.0'
end

