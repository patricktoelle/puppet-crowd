# Class crowd::config
#
class crowd::config {

  require crowd

  File {
    owner => $crowd::user,
    group => $crowd::group,
    mode    => '0644',
    require => Class['crowd::install'],
  }

  if($crowd::java_home == undef) {
    fail('Please set a value for the java_home parameter.')
  }
  file {"${crowd::webappdir}/apache-tomcat/bin/setenv.sh":
    ensure  => present,
    content => template('crowd/setenv.sh.erb'),
    mode    => '0755',
  }

  file {"${crowd::webappdir}/crowd-webapp/WEB-INF/classes/crowd-init.properties":
    content => template('crowd/crowd-init.properties.erb'),
  }

  file {"${crowd::webappdir}/apache-tomcat/conf/Catalina/localhost/openidserver.xml":
    content => template('crowd/openidserver.xml.erb'),
  }

  file {"${crowd::webappdir}/crowd-openidserver-webapp/WEB-INF/classes/jdbc.properties":
    content => template('crowd/jdbc.properties.erb'),
  }
}
