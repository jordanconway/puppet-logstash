# logstash params class

class logstash::params {

  $package = 'https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder-0.4.0-1.x86_64.rpm'
  $servers = ["logstash.${::domain}:${port}"]
  $port = 5000
  $timeout = '15'
  $use_ssl = false
  $ssl_ca = '/etc/pki/tls/certs/logstash-forwarder.crt'
  $paths = { 'paths' => ['/var/log/messages', '/var/log/secure'],
            'fields' => {
              'type' => 'syslog'
            }
          }

  if $use_ssl {
  $config = { 'network'     => {
                'servers' => $servers,
                  'timeout' => $timeout,
                  'ssl_ca'  => $ssl_ca
                },
                'files' => $paths
            }
  }
  else {
  $config = { 'network'     => {
                'servers' => $servers,
                  'timeout' => $timeout,
                },
                'files' => $paths
            }
  }
}
