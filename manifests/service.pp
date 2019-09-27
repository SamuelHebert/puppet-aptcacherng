# Private service class for aptcacherng, do not use directly!
class aptcacherng::service {
  service {'apt-cacher-ng':
    ensure => $aptcacherng::service_ensure,
    enable => $aptcacherng::service_enable,
  }
}
