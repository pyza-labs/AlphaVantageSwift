#
# Be sure to run `pod lib lint AplhaVantageSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AplhaVantageSwift'
  s.version          = '0.1.0'
  s.summary          = 'Swift wrappers for the famous Alpha Vantage API'
  s.platforms        = { :ios => 9.0, :osx => 10.10 }
  s.swift_version    = '4.1'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Here is a all in one swift wrapper for the famous trading api called Alpha Vantage
                       DESC

  s.homepage         = 'https://github.com/pyza-labs/AlphaVantageSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sourav Chandra' => 'saurav.chandra1992@live.com' }
  s.source           = { :git => 'https://github.com/pyza-labs/AlphaVantageSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'AplhaVantageSwift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AplhaVantageSwift' => ['AplhaVantageSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
