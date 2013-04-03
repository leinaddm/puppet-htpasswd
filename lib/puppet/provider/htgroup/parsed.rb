require 'puppet/provider/parsedfile'
htgroup_file = "/etc/httpd/conf/htgroup"

Puppet::Type.type(:htgroup).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => htgroup_file,
  :filetype => :flat
) do

  desc "htgroup provider that uses the ParsedFile class"

  text_line :comment, :match => /^#/;
  text_line :blank, :match => /^\s*$/;
  record_line :parsed, :fields => %w{name users}, :joiner => ':', :separator => ':',
    :block_eval => :instance do
      def post_parse(hash)
        hash[:users] = hash[:users].strip.split.sort
        hash
      end

      def pre_gen(hash)
        hash[:users] = hash[:users].sort.join(' ')
        hash
      end
    end
end
