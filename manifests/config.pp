# == Class: dokku::config
#
# Configures the actual dokku installation. Private.
#
# === Parameters
# [*hostname*]
# Hostname of the dokku

# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
class dokku::config (
  $ensure   = $::dokku::ensure,
  $hostname = $::dokku::hostname,
  $vhost    = $::dokku::vhost,
  $data_dir = $::dokku::data_dir,
) {

  include dokku::params

  file { "${data_dir}/VHOST":
    ensure  => 'present',
    content => epp("${module_name}/vhost.epp", { 'vhost' => $vhost }),
    require => Class['dokku::install']
  }

  file { "${data_dir}/HOSTNAME":
    ensure  => 'present',
    content => epp("${module_name}/hostname.epp", { 'hostname' => $hostname }),
    require => Class['dokku::install']
  }
}
