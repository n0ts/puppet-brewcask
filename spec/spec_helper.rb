require "rspec-puppet"

fixture_path = File.expand_path File.join(__FILE__, "..", "fixtures")

RSpec.configure do |c|
  c.manifest_dir = File.join(fixture_path, "manifests")
  c.module_path  = File.join(fixture_path, "modules")
end

def default_test_facts
  {
    :boxen_home    => "/test/boxen",
    :boxen_srcdir  => "/test/boxen/src",
    :boxen_repodir =>  File.join(File.dirname(__FILE__), 'fixtures'),
    :boxen_repo_url_template => "https://github.com/%s",
    :boxen_user    => "testuser",
    :homebrew_root => '/opt/boxen/homebrew',
  }
end
