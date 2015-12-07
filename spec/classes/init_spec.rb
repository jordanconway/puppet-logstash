require 'spec_helper'
describe 'logstash' do
  let(:facts) {
    {
      :fqdn            => 'test.example.com',
      :hostname        => 'test',
      :ipaddress       => '192.168.0.1',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat'
    }
  }

  context 'with defaults for all parameters' do
    it { should contain_class('logstash') }
    it { should contain_class('logstash::forwarder') }
  end

end
