require 'puppet/provider/parsedfile'
htpasswd_file = "/etc/httpd/conf/htpasswd"

Puppet::Type.type(:htpasswd).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => htpasswd_file,
  :filetype => :flat
) do

  desc "htpasswd provider that uses the ParsedFile class"

  text_line :comment, :match => /^#/;
  text_line :blank, :match => /^\s*$/;
  record_line :parsed, :fields => %w{name cryptpasswd}, :joiner => ':', :separator => ':'
end
