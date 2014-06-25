class autossh (
  $package_name   = $::autossh::params::package_name,
  $package_ensure = 'present',
) inherits autossh::params {

  package { 'autossh':
    name   => $package_name,
    ensure => $package_ensure,
  }

}
