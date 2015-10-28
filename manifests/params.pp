# logstash class

class logstash::params {

  $server = "logstash.${::domain}"
  $port = 5000
  $use_ssl = false
  $ssl_cert = 'UNSET'
  $ssl_ca = 'UNSET'
  $ssl_key = 'UNSET'
  $ssl_dir = '/etc/pki/tls/'
  $package = 'http://download.elasticsearch.org/logstash-forwarder/packages/logstash-forwarder-0.3.1-1.x86_64.rpm'
  $network::servers = ["${server}:${port}"]
  $network::servers::timeout = 15
  $network::servers::ssl_ca = $ssl_cert

  $ssl_dir = $logstash::params::ssl_dir
  $ssl_ca = $logstash::params::ssl_ca
  $ssl_cert = $logstash::params::ssl_cert
  $ssl_key = $logstash::params::ssl_key
  $package = $logstash::params::package
  $servers = $logstash::params::network::servers
  $timeout = $logstash::params::network::servers::timeout
  $conf_ssl_ca = $logstash::params::network::servers::ssl_ca


}
