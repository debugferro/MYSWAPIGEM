lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/myswapigem/version'

Gem::Specification.new do |spec|
  spec.name          = "myswapigem"
  spec.version       = MYSWAPIGEM::VERSION
  spec.authors       = ["Gabriel Fontes"]
  spec.email         = ["gabrielferroroque@hotmail.com"]

  spec.summary       = "Populate your database with SWAPI records."
  spec.description   = "You can populate your database, trough rake tasks, with SWAPI records and make requests using helpers."
  spec.homepage      = "http://www.gabrielferro.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'httparty'
  spec.add_dependency 'rake'
end
