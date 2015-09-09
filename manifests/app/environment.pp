# == Class: dokku::app::environment
#
# Adds environment variable to dokku application
#
# === Parameters
# [*variables*]
# Environment variables object
# === Authors
#
# Maxim Kotelnikov <info@impy.us>
#
define dokku::app::environment (
  $variables = undef,
) {
  if $variables {
    $target = "${::dokku::params::data_dir}/${name}/ENV"

    concat { $target:
      owner => 'dokku',
      group => 'dokku',
      mode  => '0600',
    }
    ~>
    exec { "dokku_restart_app_${name}":
      cwd         => '/usr/src/dokku',
      command     => "/usr/local/bin/dokku ps:restart ${name}",
      timeout     => 60,
      require     => Class['dokku::install'],
      refreshonly => true,
    }

    $variables.each |String $key, String $value| {
      concat::fragment{ "dokku_environment_${name}_${key}":
        target  => $target,
        content => "export ${key}=${value}\n"
      }
    }
  }
}
