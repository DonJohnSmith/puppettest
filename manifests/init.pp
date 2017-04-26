class emulator
{
  notify{ 'emulator package enabled': }

  $pkg_install = [ 'socat', 'netcat', 'git' ]
  package { $pkg_install: ensure => present }

  file { '/opt/cleveron/emulatorDevices':
    ensure => 'directory',
    owner  => 'backend',
    group  => 'backend',
    mode   => '0755'
  }

  file { '/opt/emulator' :
    ensure  => 'directory',
    recurse => remote,
    source  => 'puppet:///modules/emulator/other',
    mode    => '0755'
  }

  file { '/opt/emulator/sql' :
    ensure  => 'directory',
    recurse => remote,
    source  => 'puppet:///modules/emulator/sql',
  }

  file { '/root/h.sh':
    content => template('emulator/h.sh'),
    mode    => '0755'
  }

  file { '/root/v.sh':
    content => template('emulator/v.sh'),
    mode    => '0755'
  }

  file { '/opt/emulator/scripts' :
    ensure  => 'directory',
    recurse => remote,
    source  => 'puppet:///modules/emulator/scripts',
    mode    => '0755'
  }

  file { '/tmp/cleverland2-db.tar.gz' :
  source => "puppet:///modules/emulator/cleverland2-db.tar.gz"
  }


  file { '/opt/cleveron/emulatorDevices/start_scanner_emulator.sh':
    content => template('emulator/scanner/start_scanner_emulator.sh'),
    owner   => 'backend',
    mode    => '0755',
    require => File['/opt/cleveron/emulatorDevices'],
  }

  include emulator::doors_emulator

  include emulator::datasync

  class{ 'base::profiles::database_server':
    admin_pass          => 'admin1',
    admin_accesslist    => ['127.0.0.1/32'],
    datalink_password   => 'datalink1',
    datalink_accesslist => ['127.0.0.1/32'],
    datalink_limit      => '3',
    office_password     => 'office1',
    ecomm_password      => 'ecomm1',
    vnc_password        => 'vnc1',
    sorting_password    => 'sorting1',
    datasync_password   => 'datasync1',
    datasync_limit      => '3',
    datasync_accesslist => ['127.0.0.1/32'],
  }

}
