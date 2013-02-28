class drush {

  $drush_branch_name = "7.x-4.x"
  $drush_make_branch_name = "6.x-2.x"

  exec {
    'fetch-drush':
      cwd     => '/tmp',
      command => "/usr/bin/git clone -q --branch $drush_branch_name http://git.drupal.org/project/drush.git",
      creates => '/tmp/drush';
    'fetch-drush-make':
        cwd     => '/tmp',
        command => "/usr/bin/git clone -q --branch $drush_make_branch_name http://git.drupal.org/project/drush_make.git",
        creates => '/tmp/drush_make';
    'run-drush' :
      cwd     => '/tmp',
      command => "/usr/local/lib/drush/drush",
      require => File['/etc/drush'];
  }

  file {
    '/usr/local/lib/drush':
      ensure  => directory,
      recurse => true,
      purge   => true,
      source  => '/tmp/drush',
      require => Exec['fetch-drush'];
    '/usr/share/drush/commands/drush_make':
      ensure  => directory,
      recurse => true,
      purge   => true,
      source  => '/tmp/drush_make',
      require => Exec['fetch-drush-make'],
  }

  file { '/usr/local/bin/drush':
      ensure  => '/usr/local/lib/drush/drush',
      require => File['/usr/local/lib/drush'],
  }

  exec {'drush_first_run':
      cwd     => '/tmp',
      command => "/usr/local/bin/drush",
      require => File['/usr/local/bin/drush']
  }

	file {
	  '/etc/drush':
	  	ensure  => directory,
			mode    => 666,
      require => File['/usr/local/lib/drush']; # Package['drush'];
		'/etc/drush/aliases.drushrc.php':
			content => template('drush/etc/drush/aliases.drushrc.php'),
			ensure  => file,
			mode    => 666,
			owner   => root,
      require => File['/etc/drush'];
		'/etc/drush/drushrc.php':
			content => template('drush/etc/drush/drushrc.php'),
			ensure  => file,
			mode    => 666,
			owner   => root,
      require => File['/etc/drush'];
  }
}
