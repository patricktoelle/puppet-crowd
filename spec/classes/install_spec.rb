require 'spec_helper'

describe 'crowd::install' do

  let :pre_condition do
    "class { 'crowd': }"
  end
  context 'defaults' do
    it { is_expected.to contain_user('crowd').with({
      :shell    => '/sbin/nologin',
      :home     => '/var/local/crowd',
      :password => '*',
    })}

    it { is_expected.to contain_group('crowd') }

    it { is_expected.to contain_file('/opt/crowd') }
    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone') }
    it { is_expected.to contain_file('/var/local/crowd') }

    it { is_expected.to contain_staging__file('atlassian-crowd-2.8.3.tar.gz').with({
      :source => 'http://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-2.8.3.tar.gz',
    })}

    it { is_expected.to contain_staging__extract('atlassian-crowd-2.8.3.tar.gz').with({
      :target  => '/opt/crowd/atlassian-crowd-2.8.3-standalone',
      :creates => '/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat',
      :user    => 'crowd',
      :group   => 'crowd',
    })}

    it { is_expected.to contain_staging__file('jdbc driver').with({
      :source => 'http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.36/mysql-connector-java-5.1.36.jar',
      :target => '/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat/lib/mysql-connector-java-5.1.36.jar',
    })}

    it { is_expected.to contain_exec('chown_/opt/crowd/atlassian-crowd-2.8.3-standalone').with({
      :command => 'chown -R crowd:crowd /opt/crowd/atlassian-crowd-2.8.3-standalone',
    })}

  end
end
