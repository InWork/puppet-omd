define omd::site::set (
  $command,
  $state,
  $puppet_dir,
  $site,
) {

  $file = "${puppet_dir}/${name}.txt"
  file { $file:
    ensure=>present,
    notify => Exec["omd maintenance stop site ${site}"],
    content => $state,
  }
  ~>
  exec { "omd config ${site} ${name}":
    command => "omd config ${site} set ${command}",
    path => ['/usr/bin','/usr/sbin','/bin','/sbin',],
    require => Exec["omd maintenance stop site ${site}","omd create site ${site}"],
    notify => Exec["omd maintenance start site ${site}"],
    refreshonly => true,
  }
}
