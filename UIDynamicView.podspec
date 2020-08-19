#
# Be sure to run `pod lib lint UIDynamicView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIDynamicView'
  s.version          = '0.1.3'
  s.summary          = 'Build dynamic views FAST'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"Use this library if you want to create views FAST without creating a pesky .xib file for every single view."
DESC

# dependencies
s.dependency 'OsTools', '~> 0.3.5'
s.dependency 'youtube-ios-player-helper', '~> 0.1.4'
s.swift_versions = "5.0"

s.homepage         = 'https://github.com/osfunapps/UIDynamicView'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'osfunapps' => 'osfunapps@gmail.com' }
  s.source           = { :git => 'https://github.com/osfunapps/UIDynamicView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = "Classes/*.swift"
#
#  s.subspec "Classes" do |ss|
#      ss.source_files = "src/Classes/*.swift"
#  end
#
#  s.subspec "Views" do |ss|
#     ss.source_files = "src/Views/*.{swift}"
#  end
  
  
  s.resources = 'src/*.xib'
end
