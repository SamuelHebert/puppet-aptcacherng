# Private config class for aptcacherng, do not use directly!
class aptcacherng::config {
  file {$aptcacherng::cachedir:
    ensure  => directory,
    owner   => 'apt-cacher-ng',
    group   => 'apt-cacher-ng',
    mode    => '2755',
  }

  file {$aptcacherng::logdir:
    ensure  => directory,
    owner   => 'apt-cacher-ng',
    group   => 'apt-cacher-ng',
    mode    => '2755',
  }

  file {'/etc/apt-cacher-ng/acng.conf':
    content => template('aptcacherng/acng.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file {'/etc/apt-cacher-ng/zz_debconf.conf':
    ensure => absent,
  }

  if $aptcacherng::max_files != undef {
    file {'/etc/security/limits.d/apt-cacher-ng':
      content => template('aptcacherng/apt-cacher-ng_limits.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  } else {
    file {'/etc/security/limits.d/apt-cacher-ng':
      ensure => absent
    }
  }

  if $aptcacherng::auth_username {
    file {'/etc/apt-cacher-ng/security.conf':
      content => template('aptcacherng/security.conf.erb'),
      owner   => 'apt-cacher-ng',
      group   => 'apt-cacher-ng',
      mode    => '0600',
    }
  }

}

