# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emacs_org_protocol_server/version'

Gem::Specification.new do |spec|
  spec.name          = "emacs_org_protocol_server"
  spec.version       = EmacsOrgProtocolServer::VERSION
  spec.authors       = ["Tamara Temple"]
  spec.email         = ["tamouse@gmail.com"]

  spec.summary       = %q{Simple Sinatra server to call org-protocol with emacsclient}
  spec.description   = %q{Simple Sinatra server to call org-protocol with emacsclient}
  spec.homepage      = "https://github.com/tamouse/emacs_org_protocol_server"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "thin"
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
end
