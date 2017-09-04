module Puppet
  Puppet::Type.newtype(:htdigest) do
    @doc = "Manage an Apache style htdigest file

    htdigest { 'user':
      ensure      => present,
      cryptpasswd => 'encrypted password',
      target      => '/etc/httpd/conf/htdigest',
    }"

    ensurable

    newparam(:name, :namevar => true) do
      desc "The resource name"
    end

    newproperty(:username) do
      desc "The user name. Defaults to the resource title if not provided"
      defaultto { @resource[:name] }
    end

    newproperty(:realm) do
      desc "The realm for the given user"
      isrequired
    end

    newproperty(:cryptpasswd) do
      desc "The encrypted password for the given user"
      isrequired

      def change_to_s(old_value, desired)
        # redact cryptpasswd from logs
        "cryptpasswd changed"
      end
    end

    newproperty(:target) do
      desc "Location of the htdigest file"
      defaultto do
        if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
          @resource.class.defaultprovider.default_target
        else
          nil
        end
      end
    end
  end
end
