# == Class: dokku::params
#
# Container for module specific parameters
#
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
class dokku::params {

  $version                 = 'v0.3.26'
  $hostname                = $::fqdn
  $vhost                   = $::fqdn
  $ensure                  = 'present'
  $data_dir                = '/home/dokku'
  $plugin_dir              = '/var/lib/dokku/plugins'
  $package_source_location = 'https://github.com/progrium/dokku.git'

  case $::osfamily {
    'Debian': { }
    default: {
      fail("Class['dokku::params']: Unsupported OS: ${::osfamily}")
    }
  }
}
