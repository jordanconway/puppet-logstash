# logstash class

class logstash (

  $config = $logstash::params::config,
  $package = $logstash::params::package,
  $servers = $logstash::params::servers,
  $timeout = $logstash::params::timeout,
  $use_ssl = $logstash::params::use_ssl,
  $ssl_ca = $logstash::params::ssl_ca,
  $paths =  $logstash::params::paths,
) inherits logstash::params{

}
