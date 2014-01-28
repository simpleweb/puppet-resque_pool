# define: resque_pool::instance
#
define resque_pool::instance (
  $config_file,
  $pidfile,
  $user,
  $group,
  $app_root,
  $bin_path = 'resque-pool',
  $rack_env = 'production',
  $stdout   = undef,
  $stderr   = undef,
) {

  if $stdout {
    $stdout_path = $stdout
  } else {
    $stdout_path = "$app_root/log/resque_pool_${name}.stdout.log"
  }

  if $stderr {
    $stderr_path = $stderr
  } else {
    $stderr_path = "$app_root/log/resque_pool_${name}.stderr.log"
  }

  $options = "--daemon --appname ${name} --environment ${rack_env} --config ${config_file} --pidfile ${pidfile} --stdout ${stdout_path} --stderr ${stderr_path}"

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
