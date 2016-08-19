# Public: Variables for working with Homebrew-cask
#
# Examples
#
#   require brewcask::config

class brewcask::config {
  include boxen::config

  $cask_home = $::brewcask_root
  $cask_room = "${cask_home}/Caskroom"
}
