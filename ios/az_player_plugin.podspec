#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'az_player_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A player plugin'
  s.swift_version    = '4.2'
  s.description      = <<-DESC
A player plugin
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'AZPlayerPlugin/Classes/**/*'
  s.public_header_files = 'AZPlayerPlugin/Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '10.0'


end

