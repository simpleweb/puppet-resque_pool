# puppet-resque_pool

Puppet module for creating and managing resque-pool services

### Install

To install as a git submodule, run:

    $ git submodule add git@github.com:simpleweb/puppet-resque_pool.git modules/resque_pool

### Usage

Use this module to:

* Ensure the `resque-pool` gem is installed
* Create `resque-pool` service instances

Install gem

```puppet
include resque_pool::install
```

Create a service

```puppet
  $rack_root = "/home/acme/rack-app"

  resque_pool::instance { "acme":
    app_root => $rack_root,
    config_file => "$rack_root/config/resque-pool.yml",
    pidfile => "$rack_root/tmp/pids/resque-pool.yml",
    user => "acme",
    group => "acme",
    bin_path => "/usr/local/bin/resque-pool",
  }
```

Commands available from example above:

```sh
  $ service resque_pool_acme
  Usage: /etc/init.d/resque_pool_acme {start|stop|restart|reload|status}
```

### Configuration

Available parameters (with defaults)

```
[*config_file*] - path to the resque-pool.yml config file
[*pidfile*] - path to the pidfile
[*user*] - user to run the process as
[*group*] - group to run the process as
[*app_root*] - path to the rack application, should contain a config.ru file
[*bin_path*] - path to the resque-pool binary (resque-pool)
[*rack_env*] - rack environment (production)
[*stdout_path*] - path to the stdout log ($app_root/log/resque_pool_${name}.stdout.log)
[*stderr_path*] - path to the stderr log ($app_root/log/resque_pool_${name}.stderr.log)
```

