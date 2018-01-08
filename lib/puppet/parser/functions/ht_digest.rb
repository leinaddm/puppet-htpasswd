require 'digest/md5'

module Puppet::Parser::Functions
    newfunction(:ht_digest, :type => :rvalue, :doc => <<-EOS
      encrypt a password using htdigest. The first argument is the username, second is realm and the third the password
    EOS
    ) do |args|
      raise(Puppet::ParseError, "ht_digest(): Wrong number of arguments " +
        "given (#{args.size} for 3)") if args.size != 3

      user = args[0]
      realm = args[1]
      value = args[2]

      raise(Puppet::ParseError, 'ht_digest(): Requires a string to work with') unless user.class == String
      raise(Puppet::ParseError, 'ht_digest(): Requires a string to work with') unless realm.class == String
      raise(Puppet::ParseError, 'ht_digest(): Requires a string to work with') unless value.class == String

      ::Digest::MD5.hexdigest("#{user}:#{realm}:#{value}")
    end
end
