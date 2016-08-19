# Public: Variables for working with Homebrew-cask
#
# Examples
#
#   require brewcask::config

class brewcask::config {
  include boxen::config

  $cask_home = "${boxen::config::home}/homebrew-cask"
  $cask_room = "${cask_home}/Caskroom"
}
