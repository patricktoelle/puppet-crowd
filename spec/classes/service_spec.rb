require 'spec_helper'

describe 'crowd::service' do

  context 'default' do
    on_supported_os.each do |os, facts|
      let :pre_condition do
        "class { 'crowd': }"
      end
      context "service file on #{os}: #{facts[:operatingsystemmajrelease]}" do

        case facts[:osfamily]
        when /Redhat/i
          if facts[:operatingsystemmajrelease] == '7'
            it { is_expected.to contain_file('crowd_service').with({
              :path => '/usr/lib/systemd/system/crowd.service',
            })}
          else
            it { is_expected.to contain_file('crowd_service').with({
              :path => '/etc/init.d/crowd',
            })}
          end
        when 'Debian'
          case facts[:operatingsystem]
          when 'Ubuntu'
            if facts[:operatingsystemmajrelease] =~ /^(12|14)/
              it { is_expected.to contain_file('crowd_service').with({
                :path => '/etc/init/crowd.conf',
              })}
            else
              it { is_expected.to contain_file('crowd_service').with({
                :path => '/usr/lib/systemd/system/crowd.service',
              })}
            end
          else
            it { is_expected.to contain_file('crowd_service').with({
              :path => '/etc/init.d/crowd',
            })}
          end
        else
          it { is_expected.to contain_file('crowd_service').with({
            :path => '/etc/init.d/crowd',
          })}
        end

      end
    end
  end
end
