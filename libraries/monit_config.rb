#
# Cookbook: monit-cookbook
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
require 'poise_service/service_mixin'

module MonitCookbook
  module Resource
    class MonitConfig < Chef::Resource     
      include Poise
      provides(:monit_config)
      include PoiseService::ServiceMixin

      # @!attribute instance_name
      # @return [String]
      attribute(:instance_name, kind_of: String, :name_attribute => true)

      # @see: config options for all things monit
      attribute(:pkg, kind_of: String, default: 'monit')
      attribute(:check, kind_of: String)
      attribute(:with, kind_of: String)
      attribute(:group, kind_of: String)
      attribute(:start_program, kind_of: String)
      attribute(:stop_program, kind_of: String)
      attribute(:mode, kind_of: String)
      attribute(:user, kind_of: String)
      attribute(:every, kind_of: String)
      attribute(:test_conditions, kind_of: Array)

    end
  end

  module Provider
    class MonitConfig < Chef::Provider
      include Poise
      include PoiseService::ServiceMixin
      provides(:monit_config)

      # Create monit files
      def action_enable
        notifying_block do
          # Install package
          package new_resource.pkg do
            package_name new_resource.pkg
            action :upgrade
          end

          template "/etc/monit/conf.d/#{new_resource.instance_name}" do
            cookbook "monit"
            source "monit_check.erb"
            owner "root"
            group "root"
            variables(
              config: new_resource,
            )
          end

          file "/etc/init.d/monit" do
            action :delete
          end
        end
        super
      end

      def action_delete
        notifying_block do
          file "/etc/monit/conf.d/#{new_resource.instance_name}" do
            action :delete
          end
        end
        super
      end

      def service_options(service)
        service.service_name('monit')
        service.command('/usr/bin/monit -c /etc/monit/monitrc')
        service.restart_on_update(true)
      end
    end
  end
end
