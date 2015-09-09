# == Class: dokku::app::environment
#
# Adds domain / alias to dokku application
#
# === Parameters
# [*domains*]
# Domain names array
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
define dokku::app::domain (
  $domains = undef,
) {
  if $domains {
    $target = "${::dokku::params::data_dir}/${name}/VHOST"

    concat { $target:
      owner => 'dokku',
      group => 'dokku',
      mode  => '0600',
    }
    ~>
    exec { "dokku_rebuild_nginx_${name}":
      cwd         => '/usr/src/dokku',
      command     => "/usr/local/bin/dokku nginx:build-config ${name}",
      timeout     => 60,
      require     => Class['dokku::install'],
      refreshonly => true,
    }

    $domains.each |String $domain| {
      concat::fragment{ "dokku_domain_${name}_${domain}":
        target  => $target,
        content => "${domain}\n"
      }
    }
  }
}
