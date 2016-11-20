Pod::Spec.new do |s|
  s.name         = "iHealthDeviceLabs-iOS-SDK"
  s.version      = "2.0.7.1"
  s.summary      = "iHealth Device Labs iOS SDK."
  s.description  = <<-DESC
  iHealth Device SDK is used to accomplish the major operation: Connection Device, Online Measurement, Offline Measurement and iHealth Device Management
                   DESC
  s.homepage     = "https://github.com/iHealthDeviceLabs/"
  s.license      = "Subject to your compliance with the terms and conditions of this Agreement, IHEALTH LAB, Inc. (“IHEALTH” or “we” or “us”) grant you a limited, non-exclusive and non-transferable license to use the Software on a computer or other device, and to use the firmware on the Hardware manufactured by us for your personal use. In the event you sell or otherwise transfer the Hardware to a third party, such third party must agree to the terms of this Agreement prior to using the Software. Your use of the Software may also require you to use certain services provided by us, the use of which is governed by our Terms of Service (the “IHEALTH Service”). For the avoidance of doubt, Software may include desktop applications, firmware, mobile applications and web applications. We recommend against installing the Software on non-private computers as your private information may be compromised."
  s.author             = { "Henrik Söderqvist" => "henrik.soderqvist@capgemini.com" }
  s.social_media_url   = "http://twitter.com/henkesoderqvist"
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/mtlhd/iHealthDeviceLabs-iOS.git", :commit => "08246627280fe1a2cbb66c3add886770c0542f0b" }
  s.source_files  = "lib/**/*.h"
  s.public_header_files = "lib/**/*.h"
  s.vendored_libraries = "lib/libiHealthSDK2.0.7.1.a"
  s.preserve_paths      = "lib/libiHealthSDK2.0.7.1.a"
end
