Pod::Spec.new do |s|
  s.name = "SwiftQrCodeScanner"
  s.version = '0.0.1'
  s.summary = "SwiftQrCodeScanner is a 1D/2D code(i.e QR/DataMatrix code) scanner framework, written in swift."
  s.platform = :ios, "10.0"
  s.author = { "Manish Rathi" => "manishrathi19902013@gmail.com" }
  s.license	= 'MIT'
  s.homepage = 'https://github.com/crazymanish/SwiftQrCodeScanner'
  s.source = { :git => 'https://github.com/crazymanish/SwiftQrCodeScanner.git', :tag => "#{s.version}"}
  s.source_files = ["Source/SwiftQrCodeScanner/SwiftQrCodeScanner/**/*.{h,swift}"]
  s.requires_arc = true
  s.frameworks = 'AVFoundation', 'Foundation', 'UIKit'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
  s.swift_version = '4.2'
end
