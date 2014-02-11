require 'digest/md5'
require 'stringio'

Puppet::Parser::Functions::newfunction(:ht_md5, :type => :rvalue, :doc => <<-EOS
      encrypt a password using apache md5 algorithm. The first argument is the password and the second one the salt to use
    EOS
  ) do |args|
    raise(Puppet::ParseError, "ht_md5(): Wrong number of arguments " +
      "given (#{args.size} for 2)") if args.size != 2

    value = args[0]
    salt = args[1]

    raise(Puppet::ParseError, 'ht_md5(): Requires a string to work with') unless value.class == String
    raise(Puppet::ParseError, 'ht_md5(): Requires a string to work with') unless salt.class == String

    # from https://github.com/copiousfreetime/htauth/blob/master/lib/htauth/algorithm.rb
    # this is not the Base64 encoding, this is the to64() method from apr
    SALT_CHARS = (%w[ . / ] + ("0".."9").to_a + ('A'..'Z').to_a + ('a'..'z').to_a).freeze
    def to_64(number, rounds)
      r = StringIO.new
      rounds.times do |x|
        r.print(SALT_CHARS[number % 64])
        number >>= 6
      end
      return r.string
    end

    # from https://github.com/copiousfreetime/htauth/blob/master/lib/htauth/md5.rb
    DIGEST_LENGTH = 16
    def encode(password, salt)
      prefix = '$apr1$'

      primary = ::Digest::MD5.new
      primary << password
      primary << prefix
      primary << salt

      md5_t = ::Digest::MD5.digest("#{password}#{salt}#{password}")

      l = password.length
      while l > 0 do
        slice_size = ( l > DIGEST_LENGTH ) ? DIGEST_LENGTH : l
        primary << md5_t[0, slice_size]
        l -= DIGEST_LENGTH
      end

      # weirdness
      l = password.length
      while l != 0
        case (l & 1)
        when 1
          primary << 0.chr
        when 0
          primary << password[0,1]
        end
        l >>= 1
      end

      pd = primary.digest

      encoded_password = "#{prefix}#{salt}$"

      # apr_md5_encode has this comment about a 60Mhz Pentium above this loop.
      1000.times do |x|
        ctx = ::Digest::MD5.new
        ctx << (( ( x & 1 ) == 1 ) ? password : pd[0,DIGEST_LENGTH])
        (ctx << salt) unless ( x % 3 ) == 0
        (ctx << password) unless ( x % 7 ) == 0
        ctx << (( ( x & 1 ) == 0 ) ? password : pd[0,DIGEST_LENGTH])
        pd = ctx.digest
      end


      l = (pd[ 0].ord<<16) | (pd[ 6].ord<<8) | pd[12].ord
      encoded_password << to_64(l, 4)

      l = (pd[ 1].ord<<16) | (pd[ 7].ord<<8) | pd[13].ord
      encoded_password << to_64(l, 4)

      l = (pd[ 2].ord<<16) | (pd[ 8].ord<<8) | pd[14].ord
      encoded_password << to_64(l, 4)

      l = (pd[ 3].ord<<16) | (pd[ 9].ord<<8) | pd[15].ord
      encoded_password << to_64(l, 4)

      l = (pd[ 4].ord<<16) | (pd[10].ord<<8) | pd[ 5].ord
      encoded_password << to_64(l, 4)
      encoded_password << to_64(pd[11].ord,2)

      return encoded_password
    end

    encode(value, salt)
  end
