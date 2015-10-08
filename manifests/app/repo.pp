# == Class: dokku::app::repo
#
# Creates a tarball from an app source and imports into dokku
#
# === Parameters
# [*app*]
# The Application name
# [*provider*]
# Repository provider, default "git"
# [*source*]
# The URL to the repo
# [*key*]
# Private key file to access the repo, usually a deploy key
# [*revision*]
# Tag name to checkout
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
class dokku::app::repo (
  $app     = undef,
  $provider = 'git',
  $source   = undef,
  $revision = undef,
  $key      = undef,
) {
  validate_string($app)
  validate_string($provider)
  validate_string($source)
  validate_string($revision)
  validate_string($key)

  $path    = "/tmp/${app}"
  $tarball = "/tmp/${app}.tar"
  $key_name = "dokku_application_${app}"

  if $key {
    file { '/etc/pki':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
      before => File[$path],
    }
    ->
    file { "/etc/pki/${key_name}":
      content => file($key),
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
    }
  }

  file { $path: ensure => 'directory' }
  ->
  file { $tarball: ensure => 'absent' }
  ->
  vcsrepo { $path:
    ensure   => present,
    provider => $provider,
    identity => "/etc/pki/${key_name}",
    source   => $source,
    revision => $revision,
    notify   => [
      Exec['create_tarball'],
      Exec["/bin/cat ${tarball} | /usr/local/bin/dokku tar:in ${app}"]
    ]
  }

  exec { 'create_tarball':
    command => "/bin/tar -C ${path} -zcvf ${tarball} .",
    timeout => 1800,
  }
  ->
  exec { "/bin/cat ${tarball} | /usr/local/bin/dokku tar:in ${app}":
    cwd     => '/usr/src/dokku',
    timeout => 1800,
    require => [
      Class['dokku::install'],
      Class['dokku::app::create']
    ],
  }
}
