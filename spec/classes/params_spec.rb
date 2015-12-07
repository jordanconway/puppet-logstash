require 'spec_helper'
describe 'logstash::params' do
  # Force our osfamily so that our params class doesn't croak
  let(:facts) {
    {
      :osfamily => 'RedHat'
    }
  }

  context 'with defaults for all parameters' do
    it { should contain_class('logstash::params') }
  end
end
