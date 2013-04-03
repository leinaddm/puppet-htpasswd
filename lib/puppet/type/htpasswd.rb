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
      desc "The user name"
    end

    newproperty(:cryptpasswd) do
      desc "The encrypted password for the given user"
      isrequired
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
