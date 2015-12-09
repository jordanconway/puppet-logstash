# logstash class

class logstash (

  $package = $logstash::params::package,
  $config = $logstash::params::config,

) inherits logstash::params{

}
