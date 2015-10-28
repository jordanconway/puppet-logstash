# logstash server stub class

class logstash::server inherits logstash {

  if $logstash::use_ssl {

    file { "${logstash::ssldir}/private/logstash-forwarder.key":
      owner  => 'root',
      group  => '0',
      mode   => '0400',
      source => $logstash::ssl_key,
    
    file { "${logstash::ssldir}/certs/logstash-forwarder.ca":
      owner  => 'root',
      group  => '0',
      mode   => '0444',
      source => $logstash::ssl_ca,
    }

  }

}
