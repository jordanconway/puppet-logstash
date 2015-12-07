require 'spec_helper'
describe 'logstash' do
#  let(:facts) {
#    {
#      :fqdn            => 'test.example.com',
#      :hostname        => 'test',
#      :ipaddress       => '192.168.0.1',
#      :operatingsystem => 'CentOS',
#      :operatingsystemmajrelease => '7',
#      :osfamily        => 'RedHat'
#    }
#  }
 on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'with defaults for all parameters' do
        it { should contain_class('logstash') }
        it { should contain_class('logstash::forwarder') }
      end
    end
  end
end
