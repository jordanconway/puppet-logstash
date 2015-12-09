# == Class: logstash::forwader
#
# Installs and configures logstash::forwarder
class logstash::forwarder (
  $package = $logstash::params::package,
  $config = hiera_hash(logstash::config, $::logstash::params::config)
) inherits logstash {

  case $::operatingsystem {
    'CentOS','RedHat': {
      case $::operatingsystemmajrelease {
        '6': {
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
        '7': {
          file { '/usr/lib/systemd/system/logstash-forwarder.service':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            source  => 'puppet:///modules/logstash/usr/lib/systemd/system/logstash-forwarder.service',
            require => Package['logstash-forwarder']
          }

          service {'logstash-forwarder':
            ensure     => running,
            enable     => true,
            hasstatus  => true,
            hasrestart => true,
            require    => [
              Package['logstash-forwarder'],
              File['/usr/lib/systemd/system/logstash-forwarder.service'],
              File['/etc/logstash-forwarder/logstash-forwarder.conf'],
            ],
            subscribe  =>  [
              File['/etc/logstash-forwarder/logstash-forwarder.conf'],
            ]
          }
        }
        default: { fail("logstash::forwarder has no love for  ${::operatingsystem} ${::operatingsystemmajrelease}") } # lint:ignore:80chars
      }
    }
    default: { fail("logstash::forwarder has no love for ${::operatingsystem}") } # lint:ignore:80chars
  }
          
  package { 'logstash-forwarder':
    ensure   => installed,
    provider => 'rpm',
    source   => $package
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
    content => template('logstash/logstash-forwarder.conf.erb'),
    require => [File['/etc/logstash-forwarder'],Package['logstash-forwarder']]
  }
}
