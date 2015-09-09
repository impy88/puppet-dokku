# == Class: dokku::app::create
#
# Creates a application in dokku
#
# === Parameters
# [*app*]
# The Application name
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
class dokku::app::create (
  $app     = undef,
) {
  validate_string($app)

  if $app {
    exec { 'dokku_create_application':
      cwd     => '/usr/src/dokku',
      command => "/usr/local/bin/dokku apps:create ${app}",
      timeout => 1800,
      unless  => "/usr/local/bin/dokku apps | grep -c ${app}",
      require => Class['dokku::install'],
    }
  }
}
