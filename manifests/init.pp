# Public: Install and configure homebrew-cask for use with Boxen.
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
    before  => Package['brew-cask'],
    require => File[$cask_home]
  }

  boxen::env_script { 'homebrew-cask':
    content  => template('brewcask/env.sh.erb'),
    priority => normal
  }

  Package['brew-cask'] -> Package <| provider == brewcask |>
}
