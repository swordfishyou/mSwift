Pod::Spec.new do |s|
  s.name         = "mSwift"
  s.version      = "0.1"
  s.summary      = "A small eDSL for functional operations with Optional and Array"
  s.homepage     = "https://github.com/swordfishyou/mSwift.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Tukhtarov Anatoly" => "anvitu@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/swordfishyou/mSwift.git", :tag => "v0.1" }
  s.source_files  = "m-Swift/**"
  s.swift_version = "3.2"
end
