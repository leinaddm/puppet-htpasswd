module Puppet
  newtype(:htpasswd) do
    @doc = "Manage an Apache style htpasswd file

    htpasswd { 'user':
      ensure      => present,
      cryptpasswd => 'encrypted password',
      target      => '/etc/httpd/conf/htpasswd',
    }"

    ensurable

    newparam(:name, :namevar => true) do
      desc "The resource name"
    end

    newproperty(:username) do
      desc "The user name. Defaults to the resource title if not provided"
      defaultto { @resource[:name] }
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
      desc "Location of the htpasswd file"
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
