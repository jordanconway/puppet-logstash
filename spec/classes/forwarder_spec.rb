require 'spec_helper'
describe 'logstash::forwarder' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'with defaults for all parameters' do
        it { should contain_class('logstash::forwarder')}
        it { should contain_package('logstash-forwarder').with(
          'ensure'   => 'installed',
          'provider' => 'rpm',
          'source'   => 'https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder-0.4.0-1.x86_64.rpm', 
       ) }
        it { should contain_file('/etc/logstash-forwarder').with(
          'ensure'   => 'directory',
          'owner' => 'root',
          'group' => 'root',
          'mode' => '0644',
          ).that_requires('Package[logstash-forwarder]') }
      end
      if facts[:operatingsystemrelease] == 6 
        it { should contain_file('/etc/sysconfig/logstash-forwarder').with(
          'ensure'   => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          'source' => 'puppet:///modules/logstash/etc/sysconfig/logstash-forwarder',
          ).that_requires('Package[logstash-forwarder]').with_content('
# From The Logstash Book
# # The original of this file can be found at: http://logstashbook.com/code/index.html
# #
# # Options for the Logstash Forwarder
# LOGSTASH_FORWARDER_OPTIONS="-config /etc/logstash-forwarder/logstash-forwarder.conf -spool-size 100"
          ')}
        it { should contain_file('/etc/init.d/logstash-forwarder').with(
          'ensure'   => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
          'source' => 'puppet:///modules/logstash/etc/init.d/logstash-forwarder',
          ).that_requires('Package[logstash-forwarder]').with_content('
#! /bin/sh
# From The Logstash Book
# The original of this file can be found at: http://logstashbook.com/code/index.html
#
# logstash-forwarder Start/Stop logstash-forwarder
#
# chkconfig: 345 99 99
# description: logstash-forwarder
# processname: logstash-forwarder

# Check config
test -f /etc/sysconfig/logstash-forwarder && . /etc/sysconfig/logstash-forwarder

LOGSTASH_FORWARDER_BIN="/opt/logstash-forwarder/bin/logstash-forwarder"

find_logstash_forwarder_process () {
    PIDTEMP=`pgrep -f ${LOGSTASH_FORWARDER_BIN}`
    # Pid not found
    if [ "x$PIDTEMP" = "x" ]; then
        PID=-1
    else
        PID=$PIDTEMP
    fi
}

start () {
  nohup ${LOGSTASH_FORWARDER_BIN} ${LOGSTASH_FORWARDER_OPTIONS} &
}

stop () {
  pkill -f ${LOGSTASH_FORWARDER_BIN}
}

case $1 in
start)
        start
        ;;
stop)
        stop
        exit 0;
        ;;
reload)
        stop
        start
        ;;
restart)
        stop
        start
        ;;
status)
        find_logstash_forwarder_process
        if [ $PID -gt 0 ]; then
            exit 0
        else
            exit 1
fi
        ;;
*fi)
        echo $"Usage: $0 {start|stop|restart|reload|status}"
        RETVAL=1
esac
exit 0
          ')}
        it { should contain_service('logstash-forwarder').with(
          'ensure'     => 'running',
          'enable'     => true,
          'hasstatus'  => true,
          'hasrestart' => true, 
          ).that_requires(
            'Package[logstash-forwarder]',
            'File[/etc/sysconfig/logstash-forwarder]',
            'File[/etc/init.d/logstash-forwarder]',
            'File[/etc/logstash-forwarder/logstash-forwarder.conf]',
          ).that_subscribes(
            'File[/etc/logstash-forwarder/logstash-forwarder.conf]',
            'File[/etc/sysconfig/logstash-forwarder]',) }
      elsif facts[:operatingsystemrelease] == 7
        it { should contain_file('/usr/lib/systemd/system/logstash-forwarder.service').with(
          'ensure'   => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0644',
          'source' => 'puppet:///modules/logstash/logstash-forwarder.service',
         ).that_requires('Package[logstash-forwarder]').with_content('
[Unit]
Description=Logstash Forwarder is a tool to collect logs locally in preparation for processing elsewhere!
Documentation=https://github.com/elasticsearch/logstash-forwarder
After=network.target remote-fs.target nss-lookup.target
 
[Service]
User=root
Group=root
Type=simple
PIDFile=/var/run/logstash-forwarder.pid
ExecStart=/opt/logstash-forwarder/bin/logstash-forwarder -config /etc/logstash-forwarder/logstash-forwarder.conf -spool-size 100
PrivateTmp=true
 
[Install]
WantedBy=multi-user.target
          ')}
        it { should contain_service('logstash-forwarder').with(
          'ensure'     => 'running',
          'enable'     => true,
          'hasstatus'  => true,
          'hasrestart' => true, 
          ).that_requires(
            'Package[logstash-forwarder]',
            'File[/usr/lib/systemd/system/logstash-forwarder.service]',
            'File[/etc/logstash-forwarder/logstash-forwarder.conf]',
          ).that_subscribes(
            'File[/etc/logstash-forwarder/logstash-forwarder.conf]',) }
      end
    end
  end
end
