# logstash class

class logstash (

  $package = $logstash::params::package,

) inherits logstash::params{

  class { '::logstash::forwarder':
    package     => $package,
  }

}
