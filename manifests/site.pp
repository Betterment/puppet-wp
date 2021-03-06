define wp::site (
    $location = $title,
    $url,
    $siteurl = $url,
    $sitename       = 'WordPress Site',
    $admin_user     = 'admin',
    $admin_email    = 'admin@example.com',
    $admin_password = 'password',
    $network        = false,
    $subdomains     = false
) {
    include wp::cli

    if ( $network == true ) and ( $subdomains == true ) {
        $install = "multisite-install --subdomains --url='$url'"
    }
    elsif ( $network == true ) {
        $install = "multisite-install --url='$url'"
    }
    else {
        $install = "install --url='$url'"
    }

    exec {"download core $location":
        command => "/usr/local/bin/wp core download",
        cwd => $location,
        creates => "$location/wp-config-sample.php",
        require => [ Class['wp::cli'] ],
    }

    exec {"wp install $location":
        command => "/usr/local/bin/wp core $install --title='$sitename' --admin_email='$admin_email' --admin_name='$admin_user' --admin_password='$admin_password'",
        cwd => $location,
        require => [ Class['wp::cli'], Exec["download core $location"] ],
        unless => '/usr/local/bin/wp core is-installed'
    }

    if $siteurl != $url {
        wp::option {"wp siteurl $location":
            location => $location,
            ensure => "equal",
            key => "siteurl",
            value => $siteurl
        }
    }
}
