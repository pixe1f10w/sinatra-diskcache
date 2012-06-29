# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sinatra/version"

Gem::Specification.new do |s|
  s.name        = "sinatra-diskcache"
  s.version     = Sinatra::DiskCache::VERSION
  s.authors     = ["Ilia Zhirov"]
  s.email       = ["izhirov@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Sinatra disk cache}
  s.description = %q{Allows to cache heavy-load query results on the disk}

  s.rubyforge_project = "sinatra-diskcache"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
