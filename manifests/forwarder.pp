# == Class: logstash::forwader
#
# Installs and configures logstash::forwarder
class logstash::forwarder (

  $server,
  $port,
  $ssl_dir,
  $ssl_ca,
  $ssl_cert,
  $ssl_key,
  $package,
  $servers,
  $timeout,
  $conf_ssl_ca,
) {

  $config = hiera_hash(logstash::config,'UNSET')

  if $logstash::use_ssl {
    file { "${logstash::ssl_dir}/certs/logstash-forwarder.ca":
      owner    => 'root',
      group    => '0',
      mode     => '0444',
      source   => $logstash::ssl_ca,
      notifies => Service['logstash-forwarder']
    }
  }

  package { 'logstash-forwarder':
    ensure   => installed,
    provider => 'rpm',
    source   => $logstash::package
  }

  file { '/etc/sysconfig/logstash-forwarder':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/logstash/etc/sysconfig/logstash-forwarder',
    require => Package['logstash-forwarder']
  }

  file { '/etc/init.d/logstash-forwarder':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/logstash/etc/init.d/logstash-forwarder',
    require => Package['logstash-forwarder']
  }
  
  file { '/etc/logstash-forwarder':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['logstash-forwarder']
  }

  file { '/etc/logstash-forwarder/logstash-forwarder.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('logstash/etc/logstash-forwarder/logstash-forwarder.conf.erb'),
    require => [File['/etc/logstash-forwarder'],Package['logstash-forwarder']]
  }

  service {'logstash-forwarder':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['logstash-forwarder'],
      File['/etc/sysconfig/logstash-forwarder'],
      File['/etc/init.d/logstash-forwarder'],
      File['/etc/logstash-forwarder/logstash-forwarder.conf'],
    ],
    subscribe  =>  [
      File['/etc/logstash-forwarder/logstash-forwarder.conf'],
      File['/etc/sysconfig/logstash-forwarder'],
    ]
  }

}
