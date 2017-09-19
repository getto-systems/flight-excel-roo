# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "flight/excel/roo/version"

Gem::Specification.new do |spec|
  spec.name          = "flight-excel-roo"
  spec.version       = Flight::Excel::Roo::VERSION
  spec.authors       = ["shun"]
  spec.email         = ["shun@getto.systems"]

  spec.summary       = %q{excel module for flight by roo}
  spec.description   = %q{read excel file, format for insert to datastore}
  spec.homepage      = "https://github.com/getto-systems/flight-excel-roo"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygens.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "roo", "~> 2.7"
end
