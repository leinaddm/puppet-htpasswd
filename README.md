# htpasswd
Puppet module to manage htpasswd and htgroup files.

This module has the ability to manage users with the same username in
multiple files. To be able to do this it uses the same approach that the
builtin cron type uses with cronjobs: a marker comment before the
managed entry. This means that you can not use this module to manage or
remove existing entries in htpasswd files. If you need to manage exiting
entries you can use https://github.com/benwtr/puppet-htpasswd , but your
usernames will have to be unique across all managed htpasswd files on
the same host.

This module does not manage the owner/group/mode of the htpasswd and
htgroup files you specify. You have to use a separate `file` resource
for that (see
[here](https://github.com/leinaddm/puppet-htpasswd/issues/1#issuecomment-23632979)
for an explanation).

## Compatibility
Puppet v3.x with Ruby v1.8.7, v1.9.3, v2.0.0

## htpasswd type

### add a user

    htpasswd { 'dan':
      cryptpasswd => 'MrC7Aq3qPKPaK',  # encrypted password
      target      => '/etc/httpd/conf/htpasswd',
    }

### add a second user with the same username to a different file

    htpasswd { 'dan2':
      username    => 'dan',
      cryptpasswd => 'djkhfsdhfkjsd',  # encrypted password
      target      => '/etc/httpd/conf/htpasswd2',
    }

### remove a user

    htpasswd { user:
      ensure => absent,
      target => '/etc/httpd/conf/htpasswd',
    }

## htgroup type

#### add a group

    htgroup { groupname:
      users  => [ user1, user2, ],
      target => '/etc/httpd/conf/htgroup',
    }

#### remove a group

    htgroup { groupname:
      ensure => absent,
      target => '/etc/httpd/conf/htgroup',
    }

## helper parser functions

### ht_crypt('password', 'salt')
encrypt 'password' with 'salt' using the crypt method

### ht_md5('password', 'salt')
encrypt 'password' with 'salt' using the apache MD5 method

### ht_sha1('password')
encrypt 'password' using the apache SHA1 method

# Credits
Apache MD5 algorithm ruby implementation taken from https://github.com/copiousfreetime/htauth by Jeremy Hinegardner.
