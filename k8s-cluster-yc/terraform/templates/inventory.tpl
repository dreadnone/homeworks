[all]
%{ for ip in master_ips ~}
master ansible_host=${ip} ansible_user=ubuntu
%{ endfor ~}
%{ for ip in worker_ips ~}
worker-${ip} ansible_host=${ip} ansible_user=ubuntu
%{ endfor ~}

[master]
%{ for ip in master_ips ~}
${ip}
%{ endfor ~}

[worker]
%{ for ip in worker_ips ~}
${ip}
%{ endfor ~}

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'