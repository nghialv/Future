Pod::Spec.new do |s|
  s.name         = "Future"
  s.version      = "0.0.3"
  s.summary      = "Swift µframework providing Future<T, Error>."
  s.homepage     = "https://github.com/nghialv/Future"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "nghialv" => "nghialv2607@gmail.com" }
  s.social_media_url   = "http://twitter.com/nghialv"

  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/nghialv/Future.git", :tag => "0.0.3" }
  s.source_files  = "Future/*.swift"
  s.requires_arc = true
  s.dependency "Result", "0.4.3"
end
