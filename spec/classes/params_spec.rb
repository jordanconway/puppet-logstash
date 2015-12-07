require 'spec_helper'
describe 'logstash::params' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'with defaults for all parameters' do
        it { should contain_class('logstash::params') }
      end
    end
  end
end
