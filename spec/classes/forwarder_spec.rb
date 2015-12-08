require 'spec_helper'
describe 'logstash::forwarder' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'with defaults for all parameters' do
        it { should contain_class('logstash::forwarder')}
        it { should contain_service('logstash-forwarder').with(
          'ensure'     => 'running',
          'enable'     => true,
          'hasstatus'  => true,
          'hasrestart' => true, 
       ) }
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
    end
  end
end
