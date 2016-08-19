Facter.add(:brewcask_root) do
  confine :operatingsystem => 'Darwin'

  # Explicit, low weight makes this easily overridable
  has_weight 1

  $brewcask_root =
    if boxen_home = Facter.value(:boxen_home)
      "#{boxen_home}/homebrew-cask"
    else
      '/opt/homebrew-cask'
    end

  setcode { $brewcask_root }
end
