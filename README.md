# puppet-resque_pool

Puppet module for creating and managing resque-pool services

### Install

To install as a git submodule, run:

    $ git submodule install git@github.com:simpleweb/puppet-resque_pool.git module/resque_pool

### Usage

Use this module to:

* Ensure the `resque-pool` gem is installed
* Create `resque-pool` service instances

Install gem

```puppet
include resque_pool::install
```
