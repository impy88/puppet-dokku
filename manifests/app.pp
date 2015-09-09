# == Class: dokku::app
#
# Adds and configure app into dokku
#
# === Parameters
# [*repo*]
# vsc-repo config object
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
define dokku::app(
  $repo,
  $config,
  $domains,
  ) {

  class { 'dokku::app::create': app => $name }

  if $repo {
    class { 'dokku::app::repo':
      app      => $name,
      provider => $repo['provider'],
      source   => $repo['source'],
      revision => $repo['revision'],
      key      => $repo['key'],
    }
  }

  ::dokku::app::environment { $name:
    variables => $config
  }

  ::dokku::app::domain { $name:
    domains   => $domains
  }
}
