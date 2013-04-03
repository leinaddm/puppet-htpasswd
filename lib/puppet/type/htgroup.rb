module Puppet
  newtype(:htgroup) do
    @doc = "Manage an Apache style htgroup file

    htgroup { 'admins':
      ensure => present,
      users  => [ddm, foo, bar],
      target => '/etc/httpd/conf/htgroup',
    }"

    ensurable

    newparam(:name, :namevar => true) do
      desc "The group name"
    end

    newproperty(:users, :array_matching => :all) do
      desc "The list of users to be included in the group"
      isrequired

      # override the comparison methods so I can compare the whole array at once
      def should_to_s(newvalue = @should)
        if newvalue
          newvalue = [newvalue] unless newvalue.is_a?(Array)
          newvalue.sort.join(" ")
        else
          nil
        end
      end

      def is_to_s(currentvalue = @is)
        if currentvalue
          return currentvalue unless currentvalue.is_a?(Array)
          currentvalue.join(" ")
        else
          nil
        end
      end

      def insync?(is)
        self.is_to_s(is) == self.should_to_s
      end
    end

    newproperty(:target) do
      desc "Location of the htgreoup file"
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
