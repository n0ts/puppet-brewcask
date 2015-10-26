# Public: Install and configure brewcask for use with Boxen.
#
# Examples
#
#   include brewcask

class brewcask (
) inherits brewcask::config {
  require homebrew

  homebrew::tap { 'caskroom/cask': }

  file { $brewcask::config::cask_home:
    ensure => directory
  }

  # This prevents typing root password the first time a cask is installed
  file { $brewcask::config::cask_room:
    ensure  => directory,
    before  => Package['brew-cask'],
    require => File[$brewcask::config::cask_home]
  }

  file { $brewcask::config::cask_bin:
    ensure  => directory,
    before  => Package['brew-cask'],
    require => File[$brewcask::config::cask_home]
  }

  boxen::env_script { 'homebrew-cask':
    content  => template('brewcask/env.sh.erb'),
    priority => normal
  }

  package { 'brew-cask':
    require  => Homebrew::Tap['caskroom/cask'],
    provider => homebrew
  }

  boxen::env_script { 'brewcask':
    content  => template('brewcask/env.sh.erb'),
    priority => highest,
  }

  Package['brew-cask'] -> Package <| provider == brewcask |>
}
