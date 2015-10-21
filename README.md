### monit Cookbook
keep your shit up

### Example with monit LWRP:
```
include_recipe 'monit'

monit_config 'nrpe' do
  action :create
  check  'process'
  with   'pidfile "/var/run/nagios/nrpe.pid"'
  start_program   "/bin/bash -c '/bin/sleep 5; /etc/init.d/nagios-nrpe-server start'"
  stop_program    '/etc/init.d/nagios-nrpe-server stop'
  notifies :restart, "service[monit_#{new_resource.instance_name}]", :immediately
end
```

### Usage
#### monit::default
