require 'spec_helper'

describe 'crowd::config' do

  let :pre_condition do
    "class { 'crowd': }"
  end
  context 'defaults' do
    it { is_expected.to contain_augeas('/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat/conf/server.xml').with({
      :changes => [
        "set Server/Service/Connector/#attribute/maxThreads '150'",
        "set Server/Service/Connector/#attribute/minSpareThreads '25'",
        "set Server/Service/Connector/#attribute/connectionTimeout '20000'",
        "set Server/Service/Connector/#attribute/port '8095'",
        "set Server/Service/Connector/#attribute/acceptCount '100'",
      ],
    })}

    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat/bin/setenv.sh').with({
      :content => /JAVA_HOME="\/usr\/lib\/jvm\/java"/,
    })}

    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat/bin/setenv.sh').with({
      :content => /JAVA_OPTS="-Xms256m -Xmx512m  -XX:MaxPermSize=256m/,
    })}

    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat/bin/setenv.sh').with({
      :content => /CATALINA_PID="\/opt\/crowd\/atlassian-crowd-2.8.3-standalone\/apache-tomcat\/work\/crowd.pid"/,
    })}


    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone/crowd-webapp/WEB-INF/classes/crowd-init.properties').with({
      :content => /crowd\.home=\/var\/local\/crowd/,
    })}

    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat/conf/Catalina/localhost/openidserver.xml').with({
      :content => /username="crowd"/
    })}
    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat/conf/Catalina/localhost/openidserver.xml').with({
      :content => /driverClassName="com\.mysql\.jdbc\.Driver"/
    })}
    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat/conf/Catalina/localhost/openidserver.xml').with({
      :content => /url="jdbc:mysql:\/\/localhost:3306\/crowdid/
    })}
    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone/apache-tomcat/conf/Catalina/localhost/openidserver.xml').with({
      :content => /validationQuery="Select 1"/
    })}

    it { is_expected.to contain_file('/opt/crowd/atlassian-crowd-2.8.3-standalone/crowd-openidserver-webapp/WEB-INF/classes/jdbc.properties').with({
      :content => /hibernate\.dialect=org\.hibernate\.dialect\.MySQL5InnoDBDialect/
    })}
  end
end
