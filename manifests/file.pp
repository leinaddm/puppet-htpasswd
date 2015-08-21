define htpasswd::file (
  $ensure = present,
  $mode = '0640',
  $owner = 'root',
  $group = 'root',
  $users = {},
) {
  file { $name:
    ensure => $ensure,
    mode   => $mode,
    owner  => $owner,
    group  => $group,
  }
  if $ensure == present {
    $defaults = {
      target => $name,
    }
    create_resources(htpasswd, $users, $defaults)
  }
}
