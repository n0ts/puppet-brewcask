require "pathname"
require "puppet/provider/package"
require "puppet/util/execution"

Puppet::Type.type(:package).provide :brewcask,
  :parent => Puppet::Provider::Package do
  include Puppet::Util::Execution

  confine :operatingsystem => :darwin

  has_feature :versionable
  has_feature :install_options

  # no caching, thank you
  def self.instances
    []
  end

  def self.home
    Facter.value(:homebrew_root)
  end

  def self.caskroom
    "#{Facter[:brewcask_root].value}/Caskroom"
  end

  def self.current(name)
    caskdir = Pathname.new "#{caskroom}/#{name}"
    caskdir.directory? && caskdir.children.size >= 1 && caskdir.children.sort.last.to_s
  end

  def query
    return unless version = self.class.current(@resource[:name])
    { :ensure => version, :name => @resource[:name] }
  end

  def install
    execute [ "brew", "cask", "install", "--no-binaries", @resource[:name], *install_options ].flatten, command_opts
  end

  def uninstall
    execute [ "brew", "cask", "uninstall", @resource[:name] ].flatten, command_opts
  end

  def install_options
    Array(resource[:install_options]).flatten.compact
  end

  def run(*cmds)
    brew_cmd = ["brew", "cask"] + cmds
    execute brew_cmd, command_opts
  end

  private
  # Override default `execute` to run super method in a clean
  # environment without Bundler, if Bundler is present
  def execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end

  # Override default `execute` to run super method in a clean
  # environment without Bundler, if Bundler is present
  def self.execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end

  def homedir_prefix
    case Facter[:osfamily].value
    when "Darwin" then "Users"
    when "Linux" then "home"
    else
      raise "unsupported"
    end
  end

  def default_user
    Facter.value(:boxen_user) || Facter.value(:id) || "root"
  end

  def s3_host
    Facter.value(:boxen_s3_host) || 's3.amazonaws.com'
  end

  def s3_bucket
    Facter.value(:boxen_s3_bucket) || 'boxen-downloads'
  end

  def command_opts
    opts = {
      :combine               => true,
      :custom_environment    => {
        "HOME"               => "/#{homedir_prefix}/#{default_user}",
        "PATH"               => "#{self.class.home}/bin:/usr/bin:/usr/sbin:/bin:/sbin",
        "CFLAGS"             => "-O2",
        "CPPFLAGS"           => "-O2",
        "CXXFLAGS"           => "-O2",
        "BOXEN_S3_HOST"      => "#{s3_host}",
        "BOXEN_S3_BUCKET"    => "#{s3_bucket}",
        "HOMEBREW_ROOT"      => self.class.home,
        "HOMEBREW_CACHE"     => "#{self.class.home}/../cache/homebrew",
        "HOMEBREW_CASK_OPTS" => "--caskroom=#{self.class.caskroom}",
        "HOMEBREW_NO_EMOJI"  => "Yes",
      },
      :failonfail            => true,
    }
    # Only try to run as another user if Puppet is run as root.
    opts[:uid] = default_user if Process.uid == 0
    opts
  end
end
