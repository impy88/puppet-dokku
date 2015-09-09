# == Class: dokku
#
# Entry-point for the Dokku puppet script.
#
# === Parameters
# [*ensure*]
# Ensure the dokku module is present or removed
# [*version*]
# The package version of the dokku module to use
# [*hostname*]
# Hostname of the dokku
# [*vhost*]
# Virtual root domain for dokku applications
#
# === Examples
#
# class { 'dokku':
#   ensure       => present,
#   version      => latest,
#   hostname     => $::fqdn,
#   vhost        => $::fqdn,
# }
#
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
class dokku
(
  $ensure                  = $::dokku::params::ensure,
  $hostname                = $::dokku::params::hostname,
  $vhost                   = $::dokku::params::vhost,
  $version                 = $::dokku::params::version,
  $data_dir                = $::dokku::params::data_dir,
  $package_source_location = $::dokku::params::package_source_location,
) inherits ::dokku::params {
  validate_string($version)
  validate_string($hostname)
  validate_string($vhost)
  validate_string($ensure)
  validate_string($package_source_location)
  validate_absolute_path($data_dir)

  if $ensure == present {
    anchor {
      'dokku::begin':;
      'dokku::end':;
    }

    Anchor['dokku::begin'] ->

    class {'::dokku::install':
      version                 => $version,
      package_source_location => $package_source_location,
    }

    ->

    file {$data_dir:
      ensure => directory,
      owner  => 'dokku',
    }

    ->

    class {'::dokku::config':
      ensure   => $ensure,
      hostname => $hostname,
      vhost    => $vhost,
    }

    ->

    Anchor['dokku::end']

  }
  elsif $ensure == absent {
    anchor {
      'dokku::begin':;
      'dokku::end':;
    }

    Anchor['dokku::begin'] ->

    class {'::dokku::install':
      version => $version,
    }

    ->

    class {'::dokku::config':
      ensure   => $ensure,
      hostname => $hostname,
      vhost    => $vhost,
    }

    ->

    Anchor['dokku::end']
  }

}
