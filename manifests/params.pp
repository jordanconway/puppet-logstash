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
  $servers = ["${server}:${port}"]
  $timeout = 15

}
