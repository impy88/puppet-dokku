# == Class: dokku::install
#
# Installs the dokku package on server
#
# === Parameters
# [*version*]
# The version of the dokku package to install
#
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
class dokku::install (
  $version                 = $dokku::version,
  $package_source_location = $dokku::package_source_location,
) {
  include dokku::params

  if $version and $dokku::ensure != 'absent' {
    $ensure = $version
  } else {
    $ensure = $dokku::ensure
  }

  #template("${module_name}/dokku-preseed.erb"),

  vcsrepo { '/usr/src/dokku':
    ensure   => present,
    provider => git,
    source   => $package_source_location,
    revision => $ensure,
  }
  ~>
  exec { 'run_dokku_installer':
    cwd     => '/usr/src/dokku',
    command => '/usr/bin/make install',
    timeout => 1800,
  }
}
