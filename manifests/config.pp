# Private config class for aptcacherng, do not use directly!
class aptcacherng::config {
# get parameters used in config templates from main class
  $allowuserports = $aptcacherng::allowuserports
  $auth_password = $aptcacherng::auth_password
  $auth_username = $aptcacherng::auth_username
  $bindaddress = $aptcacherng::bindaddress
  $cachedir = $aptcacherng::cachedir
  $connectproto = $aptcacherng::connectproto
  $debug = $aptcacherng::debug
  $dirperms = $aptcacherng::dirperms
  $dnscacheseconds = $aptcacherng::dnscacheseconds
  $dontcache = $aptcacherng::dontcache
  $dontcacherequested = $aptcacherng::dontcacherequested
  $dontcacheresolved = $aptcacherng::dontcacheresolved
  $exabortonproblems = $aptcacherng::exabortonproblems
  $exposeorigin = $aptcacherng::exposeorigin
  $exthreshold = $aptcacherng::exthreshold
  $fileperms = $aptcacherng::fileperms
  $forcemanaged = $aptcacherng::forcemanaged
  $foreground = $aptcacherng::foreground
  $forwardbtssoap = $aptcacherng::forwardbtssoap
  $freshindexmaxage = $aptcacherng::freshindexmaxage
  $keepextraversions = $aptcacherng::keepextraversions
  $localdirs = $aptcacherng::localdirs
  $logdir = $aptcacherng::logdir
  $logsubmittedorigin = $aptcacherng::logsubmittedorigin
  $maxconthreads = $aptcacherng::maxconthreads
  $max_files = $aptcacherng::max_files
  $maxstandbyconthreads = $aptcacherng::maxstandbyconthreads
  $networktimeout = $aptcacherng::networktimeout
  $offlinemode = $aptcacherng::offlinemode
  $passthroughpattern = $aptcacherng::passthroughpattern
  $pfilepattern = $aptcacherng::pfilepattern
  $pfilepatternex = $aptcacherng::pfilepatternex
  $pidfile = $aptcacherng::pidfile
  $port = $aptcacherng::port
  $precachefor = $aptcacherng::precachefor
  $proxy = $aptcacherng::proxy
  $recompbz2 = $aptcacherng::recompbz2
  $redirmax = $aptcacherng::redirmax
  $remap_lines = $aptcacherng::remap_lines
  $reportpage = $aptcacherng::reportpage
  $requestappendix = $aptcacherng::requestappendix
  $socketpath = $aptcacherng::socketpath
  $stupidfs = $aptcacherng::stupidfs
  $supportdir = $aptcacherng::supportdir
  $unbufferlogs = $aptcacherng::unbufferlogs
  $useragent = $aptcacherng::useragent
  $usewrap = $aptcacherng::usewrap
  $verboselog = $aptcacherng::verboselog
  $vfilepattern = $aptcacherng::vfilepattern
  $vfilepatternex = $aptcacherng::vfilepatternex
  $vfileuserangeops = $aptcacherng::vfileuserangeops
  $wfilepattern = $aptcacherng::wfilepattern
  $wfilepatternex = $aptcacherng::wfilepatternex

  file {$aptcacherng::cachedir:
    ensure => directory,
    owner  => 'apt-cacher-ng',
    group  => 'apt-cacher-ng',
    mode   => '2755',
  }

  file {$aptcacherng::logdir:
    ensure => directory,
    owner  => 'apt-cacher-ng',
    group  => 'apt-cacher-ng',
    mode   => '2755',
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

