# Private install class for aptcacherng, do not use directly!
class aptcacherng::install {
  package {$aptcacherng::package_name:
    ensure => $aptcacherng::package_ensure,
  }
}
