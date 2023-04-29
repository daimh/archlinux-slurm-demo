Computes = 1 2
Nodes = ctl $(addprefix compute,$(Computes))

test : $(addprefix var/archlinux-slurm-,$(Nodes))
#	$(Ssh222)1 root@localhost 'redis-cli --cluster create 192.168.222.1:6379 192.168.222.2:6379 192.168.222.3:6379 --cluster-yes'
	
include lib/archlinux-base.mk

define DaikerRun
	-fuser -k $@.qcow2 222$1/tcp
	rm -f $@.qcow2
	daiker run -e random -b $<.qcow2 -T 22-222$1 $@.qcow2 &
	$(Wait) $(Ssh222)$1 root@localhost id
	( cat lib/common.m4 && [ ! -f lib/$(@F).m4 ] || cat lib/$(@F).m4 ) | m4 -D m4Hostname=$(@F) -D m4Id=$1 | $(Ssh222)$1 root@localhost
endef
define TmplNode
var/archlinux-slurm-$2 : var/archlinux-base-slurm
	$$(call DaikerRun,$1)
	touch $$@
endef
$(eval $(call TmplNode,0,ctl))
$(foreach I,$(Computes),$(eval $(call TmplNode,$I,compute$I)))

var/archlinux-base-slurm : var/archlinux-base var/daiker
	$(call DaikerRun,1)
	$(Wait) ! fuser $@.qcow2
	echo $@.qcow2 | var/daiker convert $@.qcow2
	touch $@

clean :
	-fuser -k var/*.qcow2
	rm -rf var
