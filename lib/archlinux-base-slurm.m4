pacman -Syu --noconfirm
pacman -S --noconfirm vim slurm-llnl man-db
systemctl enable munge
userdel -r arch
useradd -m slurmtest
cat > /etc/slurm-llnl/slurm.conf << EOF
ClusterName=cluster
SlurmctldHost=archlinux-slurm-ctl
MpiDefault=none
ProctrackType=proctrack/cgroup
ReturnToService=1
SlurmctldPidFile=/var/run/slurmctld.pid
SlurmctldPort=6817
SlurmdPidFile=/var/run/slurmd.pid
SlurmdPort=6818
SlurmdSpoolDir=/var/spool/slurmd
SlurmUser=slurm
StateSaveLocation=/var/spool/slurmctld
SwitchType=switch/none
TaskPlugin=task/affinity,task/cgroup
InactiveLimit=0
KillWait=30
MinJobAge=300
SlurmctldTimeout=120
SlurmdTimeout=300
Waittime=0
SchedulerType=sched/backfill
SelectType=select/cons_tres
AccountingStorageType=accounting_storage/none
JobCompType=jobcomp/none
JobAcctGatherFrequency=30
JobAcctGatherType=jobacct_gather/none
SlurmctldDebug=info
SlurmctldLogFile=/var/log/slurmctld.log
SlurmdDebug=info
SlurmdLogFile=/var/log/slurmd.log
NodeName=archlinux-slurm-compute[1-4] CoresPerSocket=2 State=UNKNOWN
PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP
EOF
cat > /etc/hosts << EOF
127.0.0.1	localhost
192.168.222.220.100	archlinux-slurm-ctl
192.168.222.220.101	archlinux-slurm-compute1
192.168.222.220.102	archlinux-slurm-compute2
EOF
(sleep 1 && poweroff) &
