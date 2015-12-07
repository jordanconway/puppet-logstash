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
      end
    end
  end
end
