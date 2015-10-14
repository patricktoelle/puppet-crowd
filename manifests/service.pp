# Class crowd::service
#
class crowd::service {
  file { $crowd::service_file:
    ensure  => 'file',
    content => template($crowd::service_template),
    mode    => $crowd::service_mode,
    owner   => 'root',
    group   => 'root',
  }

  if $crowd::manage_service {
    service { 'crowd':
      ensure   => $crowd::service_ensure,
      enable   => $crowd::service_enable,
      provider => $crowd::service_provider,
    }
  }
}
