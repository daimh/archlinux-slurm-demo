ip a add 192.168.222.10m4Id/24 dev eth1
ip l set eth1 up
cp /etc/slurm-llnl/cgroup.conf.example /etc/slurm-llnl/cgroup.conf
systemctl start slurmd
systemctl enable slurmd
