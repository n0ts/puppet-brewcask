# Public: installs homebrew cask
#
# Examples
#
#    include brewcask
class brewcask {
  include boxen::config
  require homebrew

  file { "${boxen::config::envdir}/10_brewcask.sh":
    ensure => 'absent',
  }

  file { "${homebrew::config::brewsdir}/cmd/brew-boxen-cask-install.rb":
    source => 'puppet:///modules/brewcask/brew-boxen-cask-install.rb',
    mode   => '0755',
  }
}
