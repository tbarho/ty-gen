# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ty-gen/version"

Gem::Specification.new do |s|
  s.name        = "ty-gen"
  s.version     = Ty::Gen::VERSION
  s.authors     = ["Ty Barho"]
  s.email       = ["t.barho@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ty's Generators}
  s.description = %q{Generators that I use, like authentication and pages}

  s.rubyforge_project = "ty-gen"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
