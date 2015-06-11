# Class crowd::install
#
class crowd::install {

  require crowd

  $_download_url = regsubst($::crowd::download_url, '\/$', '')

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

  file { "${crowd::installdir}/atlassian-${crowd::product}-${crowd::version}-standalone":
    ensure => 'directory',
  }

  staging::file { "atlassian-${crowd::product}-${crowd::version}.${crowd::format}":
    source  => "${_download_url}/atlassian-${crowd::product}-${crowd::version}.${crowd::format}",
    require => File["${crowd::installdir}/atlassian-${crowd::product}-${crowd::version}-standalone"],
  }

  staging::extract { "atlassian-${crowd::product}-${crowd::version}.${crowd::format}":
    target  => "${crowd::installdir}/atlassian-${crowd::product}-${crowd::version}-standalone",
    strip   => '1',
    user    => $crowd::user,
    group   => $crowd::group,
    creates => "${crowd::installdir}/atlassian-${crowd::product}-${crowd::version}-standalone/apache-tomcat",
    notify  => Exec["chown_${crowd::webappdir}"],
    require => Staging::File["atlassian-${crowd::product}-${crowd::version}.${crowd::format}"],
  }

  file { '/var/log/crowd':
    ensure => 'directory',
  }

  if $crowd::db == 'mysql' {
    staging::file { 'mysql java connector':
      source => "${crowd::mavenrepopath}/${crowd::jdbcversion}/mysql-connector-java-${crowd::jdbcversion}.jar",
      target => "${crowd::webappdir}/apache-tomcat/lib/mysql-connector-java-${crowd::jdbcversion}.jar",
      before => Exec["chown_${crowd::webappdir}"],
    }
  }

  exec { "chown_${crowd::webappdir}":
    command   => "chown -R ${crowd::user}:${crowd::group} ${crowd::webappdir}",
    unless    => "find ${crowd::webappdir} ! -type l \\( ! -user ${crowd::user} -type f \\) -o \\( ! -group ${crowd::group} \\) -a \\( -type f \\)| wc -l | awk '{print \$1}' | grep -qE '^0'",
    path      => '/bin:/usr/bin',
    subscribe => User[$crowd::user],
    require   => Staging::Extract["atlassian-${crowd::product}-${crowd::version}.${crowd::format}"],
  }


}
