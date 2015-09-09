# == Class: dokku::plugin
#
# Adds plugin to dokku application
#
# === Parameters
# [*source*]
# Github source URL
# [*revision*]
# Version of plugin
#
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
define dokku::plugin (
  $source   = undef,
  $revision = undef,
) {
  file { "${::dokku::params::plugin_dir}/${name}":
    ensure => 'directory'
  }
  ->
  vcsrepo{ "${::dokku::params::plugin_dir}/${name}":
    provider => 'git',
    source   => $source,
    revision => $revision,
  }
  ~>
  exec { '/usr/local/bin/dokku plugins-install':
    cwd         => '/usr/src/dokku',
    timeout     => 1800,
    refreshonly => true,
    loglevel    => 'alert',
    require     => Class['dokku::install'],
    logoutput   => true,
  }
}
