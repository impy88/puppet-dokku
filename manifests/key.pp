# == Class: dokku::key
#
# Adds ssh-key for dokku user
#
# === Parameters
# [*type*]
# SSH key type
# [*key*]
# Key string
#
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
define dokku::key (
  $type   = undef,
  $key = undef,
) {

  ssh_authorized_key { $name:
    ensure => present,
    name   => $name,
    user   => 'dokku',
    type   => $type,
    key    => $key,
  }
}
