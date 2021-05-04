Pod::Spec.new do |s|

  s.name         = "HPLayout"
  s.version      = "2.0.0"
  s.summary      = "A simple layout DSL to make your Autolayout life a little easier"

  s.homepage     = "https://panhans.dev/opensource/hpnetwork"

  s.license      = "MIT"

  s.author             = { "Henrik Panhans" => "henrik@panhans.dev" }
  s.social_media_url   = "https://twitter.com/henrik_dmg"

  s.ios.deployment_target = "11.0"
  s.tvos.deployment_target = "11.0"

  s.source       = { :git => "https://github.com/henrik-dmg/HPLayout.git", :tag => s.version }

  s.source_files  = "Sources/HPLayout/**/*.swift"

  s.framework = "Foundation"
  s.ios.framework = "UIKit"
  s.tvos.framework = "UIKit"

  s.swift_version = "5.4"
  s.requires_arc = true

end
