module Puppet::Parser::Functions
    newfunction(:ht_crypt, :type => :rvalue, :doc => <<-EOS
      encrypt a password using crypt. The first argument is the password and the second one the salt to use
    EOS
    ) do |args|
      raise(Puppet::ParseError, "ht_crypt(): Wrong number of arguments " +
        "given (#{args.size} for 2)") if args.size != 2

      value = args[0]
      salt = args[1]

      raise(Puppet::ParseError, 'ht_crypt(): Requires a string to work with') unless value.class == String
      raise(Puppet::ParseError, 'ht_crypt(): Requires a string to work with') unless salt.class == String

      value.crypt(salt)
    end
end
