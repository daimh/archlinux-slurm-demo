ip a add 192.168.222.10m4Id/24 dev eth1
ip l set eth1 up
systemctl start slurmctld
systemctl enable slurmctld 
