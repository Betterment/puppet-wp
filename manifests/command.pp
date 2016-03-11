define wp::command (
	$location,
	$command
) {
	include wp::cli

	exec {"$location wp $command":
		command => "/usr/local/bin/wp $command",
		cwd => $location,
		user => $::wp::user,
		require => [ Class['wp::cli'] ],
		onlyif => '/usr/local/bin/wp core is-installed'
	}
}
