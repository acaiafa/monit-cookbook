# install some service
package 'nagios-nrpe-server' do
  action :install
end

# Create fake monit profile
monit_config 'nrpe' do
  check  'process'
  with   'pidfile "/var/run/nagios/nrpe.pid"'
  start_program   "/etc/init.d/nagios-nrpe-server start'"
  stop_program    '/etc/init.d/nagios-nrpe-server stop'
end
