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
          ).that_requires('Package[logstash-forwarder]') }
        it { should contain_file('/etc/init.d/logstash-forwarder').with(
          'ensure'   => 'present',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
          'source' => 'puppet:///modules/logstash/etc/init.d/logstash-forwarder',
          ).that_requires('Package[logstash-forwarder]') }
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
         ).that_requires('Package[logstash-forwarder]') }
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
