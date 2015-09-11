# == Class: dokku::key
#
# Adds ssh-key for dokku user
#
# === Parameters
# [*key*]
# Key string
#
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
define dokku::key (
  $key = undef,
) {

  exec { "dokku key add ${name}":
    command => "/bin/echo ${key} | /usr/local/bin/sshcommand acl-add dokku User ${name}",
    require => Class['dokku::install'],
  }
}
