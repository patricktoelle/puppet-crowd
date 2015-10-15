require 'spec_helper'

describe 'crowd' do

  context 'unsupported operating systems' do
    let(:facts) {{ :osfamily => 'Windows' }}
    it { expect { catalogue }.to raise_error(Puppet::Error, /not supported/) }
  end

  context 'supported operating system' do
    on_supported_os.each do |os, facts|
      context os do
        it { is_expected.to contain_class('crowd::install') }
        it { is_expected.to contain_class('crowd::config') }
        it { is_expected.to contain_class('crowd::service') }
      end
    end
  end
end
