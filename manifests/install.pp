class resque_pool::install {

  package { 'resque-pool'
    ensure => installed,
    provider => 'gem',
  }

}
