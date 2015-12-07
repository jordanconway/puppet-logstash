# logstash class

class logstash::params {

  $package = 'https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder-0.4.0-1.x86_64.rpm'

  $config = { 'network' => {
                'servers' => ['logstash.localdomain:5000'],
                              'timeout' => 15,
                              'ssl_ca' => '/etc/pki/tls/certs/logstash-forwarder.crt'
                },
                'files' => [{
                  'paths' => ['/var/log/messages', '/var/log/secure'],
                    'fields' => {
                      'type' => 'syslog'
                    }
                }]
              }
}
