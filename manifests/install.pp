# Class crowd::install
#
class crowd::install {

  require crowd

  File {
    owner => $crowd::user,
    group => $crowd::group,
  }

  file { $crowd::installdir:
    ensure => 'directory',
  }

  user { $crowd::user:
    comment    => 'Crowd daemon account',
    shell      => '/sbin/nologin',
    home       => $crowd::homedir,
    managehome => false,
  }

  file { $crowd::homedir:
    ensure  => 'directory',
    owner   => $crowd::user,
    group   => $crowd::group,
    mode    => '0750',
    require => File[$crowd::installdir],
  }

  case $crowd::service_provider {
    upstart: {
      file { '/etc/init/crowd.conf':
        content => template('crowd/etc/init/crowd.conf.erb'),
        mode    => '0644',
      }
    }
    init: {
      file { '/etc/init.d/crowd':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        content => template('crowd/etc/init.d/crowd.erb'),
        mode    => '0700'
      }
    }
    default: {
      warning("No init script provided for ${crowd::service_provider} provider.")
    }
  }

  deploy::file { "atlassian-${crowd::product}-${crowd::version}.${crowd::format}":
    target => "${crowd::installdir}/atlassian-${crowd::product}-${crowd::version}-standalone",
    url    => $crowd::downloadURL,
    strip  => true,
    owner  => $crowd::user,
    group  => $crowd::group,
    notify => Exec["chown_${crowd::webappdir}"],
  }


  exec { "chown_${crowd::webappdir}":
    command     => "/bin/chown -R ${crowd::user}:${crowd::group} ${crowd::webappdir}",
    refreshonly => true,
    subscribe   => User[$crowd::user],
    require     => Deploy::File["atlassian-${crowd::product}-${crowd::version}.${crowd::format}"],
  }

  file { '/var/log/crowd':
    ensure => 'directory',
  }

  if $crowd::db == 'mysql' {
    wget::fetch { 'mysql java connector':
      source      => "${crowd::mavenrepopath}/${crowd::jdbcversion}/mysql-connector-java-${crowd::jdbcversion}.jar",
      destination => "${crowd::webappdir}/apache-tomcat/lib/mysql-connector-java-${crowd::jdbcversion}.jar",
      timeout     => 0,
      verbose     => true,
      require     => Exec["chown_${crowd::webappdir}"]
    }
  }

}
