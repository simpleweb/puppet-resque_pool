class resque_pool::install {

  if !defined(Package['resque']) {
    package { 'resque':
      ensure => installed,
      provider => 'gem',
      require => Class['redis'],
    }
  }

  package { 'resque-pool':
    ensure => installed,
    provider => 'gem',
    require => Package['resque']
  }

}
