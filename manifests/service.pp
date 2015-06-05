# Class crowd::install
#
class crowd::service {
  service { 'crowd':
    ensure   => 'running',
    enable   => $crowd::service_enable,
    provider => $crowd::service_provider,
    require  => Class['crowd::config'],
  }
}
