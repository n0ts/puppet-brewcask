# Public: Install and configure brewcask for use with Boxen.
#
# Examples
#
#   include brewcask

class brewcask (
) inherits brewcask::config {
  require homebrew

  homebrew::tap { 'caskroom/cask': }

  package { 'brew-cask':
    require => Homebrew_Tap['caskroom/cask']
  }

  file { $cask_home:
    ensure => directory
  }

  # This prevents typing root password the first time a cask is installed
  file { $cask_room:
    ensure  => directory,
    require => File[$cask_home]
  }

  boxen::env_script { 'brewcask':
    content  => template('brewcask/env.sh.erb'),
    priority => highest,
  }
}
