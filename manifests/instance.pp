# Define: resque_pool::instance
#
# Create a resque-pool service
#
# Parameters:
#
# [*config_file*] - path to the resque-pool.yml config file
# [*pidfile*] - path to the pidfile
# [*user*] - user to run the process as
# [*group*] - group to run the process as
# [*app_root*] - path to the rack application, should contain a config.ru file
# [*bin_path*] - path to the resque-pool binary (resque-pool)
# [*rack_env*] - rack environment (production)
# [*stdout_path*] - path to the stdout log ($app_root/log/resque_pool_${name}.stdout.log)
# [*stderr_path*] - path to the stderr log ($app_root/log/resque_pool_${name}.stderr.log)
#
# Usage example:
#
#   $rack_root = "/home/acme/rack-app"
#
#   resque_pool::instance { "acme":
#     app_root => $rack_root,
#     config_file => "$rack_root/config/resque-pool.yml",
#     pidfile => "$rack_root/tmp/pids/resque-pool.yml",
#     user => "acme",
#     group => "acme",
#     bin_path => "/usr/local/bin/resque-pool",
#   }
#
# Commands available from example above:
#
#   $ service resque_pool_acme
#   Usage: /etc/init.d/resque_pool_acme {start|stop|restart|reload|status}
#
define resque_pool::instance (
  $config_file,
  $pidfile,
  $user,
  $group,
  $app_root,
  $bin_path = 'resque-pool',
  $rack_env = 'production',
  $stdout_path   = undef,
  $stderr_path   = undef,
) {

  if $stdout_path {
    $_stdout_path = $stdout_path
  } else {
    $_stdout_path = "$app_root/log/resque_pool_${name}.stdout.log"
  }

  if $stderr_path {
    $_stderr_path = $stderr_path
  } else {
    $_stderr_path = "$app_root/log/resque_pool_${name}.stderr.log"
  }

  $options = "--daemon --appname ${name} --environment ${rack_env} --config ${config_file} --pidfile ${pidfile} --stdout ${_stdout_path} --stderr ${_stderr_path}"

  $daemon      = $bin_path
  $daemon_opts = "exec unicorn ${options}"

  service { "resque_pool_${name}":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    start      => "/etc/init.d/resque_pool_${name} start",
    stop       => "/etc/init.d/resque_pool_${name} stop",
    restart    => "/etc/init.d/resque_pool_${name} reload",
    require    => [
      File["/etc/init.d/resque_pool_${name}"],
      File["/etc/default/resque_pool_${name}"],
    ],
  }

  file { "/etc/default/resque_pool_${name}":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("resque_pool/default.erb"),
    notify  => Service["resque_pool_${name}"];
  }

  file { "/etc/init.d/resque_pool_${name}":
    owner   => root,
    group   => root,
    mode    => 755,
    content => template("resque_pool/init.erb"),
    notify  => Service["resque_pool_${name}"];
  }
}
