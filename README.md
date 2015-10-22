### monit Cookbook
This cookbook assumes default monit config file. I will add support later to tweak that file.

### Example with monit LWRP:
```
include_recipe 'monit'

monit_config 'your_dope_service' do
  action :create
  check  'process'
  with   'pidfile "/var/run/your_dope_service"
  start_program   "/bin/bash -c '/bin/sleep 5; /etc/init.d/your_dope_service start'"
  stop_program    '/etc/init.d/your_dope_service stop'
  notifies :restart, "service[monit_#{new_resource.instance_name}]", :immediately
end
```

### Usage
#### monit::default
