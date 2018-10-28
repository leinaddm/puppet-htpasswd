class htpasswd::files (
  $htpasswdfiles = {},
) {
  create_resources(htpasswd::file, $htpasswdfiles)
}
