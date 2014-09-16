# Class crowd::install
#
class crowd::service {
  service { 'crowd':
    ensure    => 'running',
    provider  => $crowd::service_provider,
    require   => Class['crowd::config'],
  }
}
