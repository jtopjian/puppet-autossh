define autossh::tunnel (
  $ensure       = present,
  $ssh_key      = '~/.ssh/id_rsa',
  $ssh_host,
  $ssh_user,
  $target_host,
  $target_port,
  $local_port,
) {

  $command = "/usr/bin/autossh ${ssh_user}@${ssh_host} -i ${ssh_key} -L ${local_port}:${target_host}:${target_port} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o LogLevel=quiet -N"

  $tunnel_title = regsubst($title, '/\s+/', '_')

  case $ensure {
    present: {
      file { "/etc/init/autossh_${tunnel_title}.conf":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('autossh/init.tpl')
      }

      service { "autossh_${tunnel_title}":
        ensure  => running,
        enable  => true,
        require => File["/etc/init/autossh_${tunnel_title}.conf"],
      }
    }
    absent: {
      file { "/etc/init/autossh_${tunnel_title}":
        ensure => absent,
      }

      service { "autossh_${tunnel_title}":
        ensure => stopped,
        enable => false,
        before => File["/etc/init/autossh_${tunnel_title}.conf"],
      }
    }
  }

}
