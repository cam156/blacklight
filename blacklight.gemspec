# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), "lib/blacklight/version")

Gem::Specification.new do |s|
  s.name        = "blacklight"
  s.version     = Blacklight::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jonathan Rochkind", "Matt Mitchell", "Chris Beer", "Jessie Keck", "Jason Ronallo", "Vernon Chapman", "Mark A. Matienzo", "Dan Funk", "Naomi Dushay"]
  s.email       = ["blacklight-development@googlegroups.com"]
  s.homepage    = "http://projectblacklight.org/"
  s.summary     = "Blacklight provides a discovery interface for any Solr (http://lucene.apache.org/solr) index."
  s.description = %q{Blacklight is an open source Solr user interface discovery platform. You can use Blacklight to enable searching and browsing of your collections. Blacklight uses the Apache Solr search engine to search full text and/or metadata.}
  
  s.rubyforge_project = "blacklight"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # PRODUCTION GEM REQUIREMENTS
  # ---------------------------------------   
  s.add_dependency "rails",     "~> 3.1"
  s.add_dependency "nokogiri",  "~>1.5"     # XML Parser
  s.add_dependency "unicode"                # provides C-form normalization of unicode characters, as required by refworks.
  # Let's allow future versions of marc, count on
  # them to be backwards compat until 1.1
  s.add_dependency "marc",      ">= 0.4.3", "< 1.1"  # Marc record parser.
  s.add_dependency "rsolr",     "~> 1.0.6"  # Library for interacting with rSolr.
  s.add_dependency "rsolr-ext", '~> 1.0.3'  # extension to the above for some rails-ish behaviors - currently embedded in our solr document ojbect.
  s.add_dependency "kaminari"               # the pagination (page 1,2,3, etc..) of our search results
  s.add_dependency "sass-rails"
  s.add_development_dependency "jettywrapper", ">= 1.2.0"
  s.add_dependency "compass-rails", "~> 1.0.0"
  s.add_dependency "compass-susy-plugin", ">= 0.9.0"
end
