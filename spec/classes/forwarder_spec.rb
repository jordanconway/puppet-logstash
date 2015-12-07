require 'spec_helper'
describe 'logstash::forwarder' do
  # Force our osfamily so that our forwarder class doesn't croak
  let(:facts) {
    {
      :fqdn            => 'test.example.com',
      :hostname        => 'test',
      :ipaddress       => '192.168.0.1',
      :operatingsystem => 'CentOS',
      :operatingsystemmajrelease => '7',
      :osfamily        => 'RedHat'
    }
  }

  context 'with defaults for all parameters' do
    it { should contain_class('logstash::forwarder')}
  end
end
