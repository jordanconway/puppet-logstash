# logstash class

class logstash (

  $server = $logstash::params::server,
  $port = $logstash::params::port,
  $ssl_dir = $logstash::params::ssl_dir,
  $ssl_ca = $logstash::params::ssl_ca,
  $ssl_cert = $logstash::params::ssl_cert,
  $ssl_key = $logstash::params::ssl_key,
  $package = $logstash::params::package,
  $servers = $logstash::params::network::servers,
  $timeout = $logstash::params::network::servers::timeout,
  $conf_ssl_ca = $logstash::params::network::servers::ssl_ca

){
  include logstash::params

}
