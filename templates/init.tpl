description "autossh tunnel"
author "Joe Topjian"

start on (local-filesystems and net-device-up IFACE=eth0)
stop on runlevel [016]

respawn
respawn limit 5 60

exec <%= @command %>
