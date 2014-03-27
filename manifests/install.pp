class resque_pool::install {

  package { 'resque':
    ensure => installed,
    provider => 'gem',
    require => Class['redis'],
  }

  package { 'resque-pool':
    ensure => installed,
    provider => 'gem',
  }

}
