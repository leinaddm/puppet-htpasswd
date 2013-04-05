require 'puppet/provider/parsedfile'
htpasswd_file = "/etc/httpd/conf/htpasswd"

Puppet::Type.type(:htpasswd).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => htpasswd_file,
  :filetype => :flat
) do

  desc "htpasswd provider that uses the ParsedFile class"

  text_line :blank, :match => /^\s*$/
  text_line :comment, :match => /^#/,
    :post_parse => proc { |record| record[:name] = $1 if record[:line] =~ /Puppet Name: (.+)\s*$/ }
  record_line :parsed, :fields => %w{username cryptpasswd},
    :joiner => ':',
    :separator => ':',
    :block_eval => :instance do
      def to_line(record)
        str = ""
        str = "# Puppet Name: #{record[:name]}\n" if record[:name]
        str += "#{record[:username]}:#{record[:cryptpasswd]}"
      end
    end

  def self.prefetch_hook(records)
    name = nil
    res = records.each do |record|
      case record[:record_type]
      when :comment
        if record[:name]
          name = record[:name]
          record[:skip] = true
        end
      else
        record[:name] = name
      end
    end.reject { |record| record[:skip] }
  end
end
