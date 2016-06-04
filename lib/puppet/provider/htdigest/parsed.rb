require 'puppet/provider/parsedfile'
htdigest_file = "/etc/httpd/conf/htdigest"

Puppet::Type.type(:htdigest).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => htdigest_file,
  :filetype => :flat
) do

  desc "htdigest provider that uses the ParsedFile class"

  text_line :blank, :match => /^\s*$/
  text_line :comment, :match => /^#/,
    :post_parse => proc { |record| record[:name] = $1 if record[:line] =~ /Puppet Name: (.+)\s*$/ }
  record_line :parsed, :fields => %w{username realm cryptpasswd},
    :joiner => ':',
    :separator => ':',
    :block_eval => :instance do
      def to_line(record)
        str = ""
        str = "# Puppet Name: #{record[:name]}\n" if record[:name]
        str += "#{record[:username]}:#{record[:realm]}:#{record[:cryptpasswd]}"
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
