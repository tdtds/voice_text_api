# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'voice_text_api/version'

Gem::Specification.new do |spec|
  spec.name          = "voice_text_api"
  spec.version       = VoiceTextAPI::VERSION
  spec.authors       = ["TADA Tadashi"]
  spec.email         = ["t@tdtds.jp"]
  spec.summary       = %q{API of VoiceText}
  spec.description   = %q{API of VoiceText, See https://cloud.voicetext.jp/webapi}
  spec.homepage      = "https://github.com/tdtds/voice_text_api"
  spec.license       = "GPL"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
