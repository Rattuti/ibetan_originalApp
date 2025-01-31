# -*- encoding: utf-8 -*-
# stub: feedjira 3.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "feedjira".freeze
  s.version = "3.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/feedjira/feedjira/blob/master/CHANGELOG.md", "homepage_uri" => "https://github.com/feedjira/feedjira", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/feedjira/feedjira" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Adam Hess".freeze, "Akinori Musha".freeze, "Ezekiel Templin".freeze, "Jon Allured".freeze, "Julien Kirch".freeze, "Michael Stock".freeze, "Paul Dix".freeze]
  s.date = "2022-10-19"
  s.homepage = "https://github.com/feedjira/feedjira".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7".freeze)
  s.rubygems_version = "3.3.7".freeze
  s.summary = "A feed parsing library".freeze

  s.installed_by_version = "3.3.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<loofah>.freeze, [">= 2.3.1"])
    s.add_runtime_dependency(%q<sax-machine>.freeze, [">= 1.0"])
    s.add_development_dependency(%q<faraday>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop-performance>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop-rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop-rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<yard>.freeze, [">= 0"])
  else
    s.add_dependency(%q<loofah>.freeze, [">= 2.3.1"])
    s.add_dependency(%q<sax-machine>.freeze, [">= 1.0"])
    s.add_dependency(%q<faraday>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-performance>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-rake>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop-rspec>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
  end
end
