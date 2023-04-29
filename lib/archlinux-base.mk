SshOpts = -i var/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o BatchMode=yes -o LogLevel=error
Ssh222 = ssh $(SshOpts) -Tp 222
Wait = function wt { touch $@.w && while ! $(SHELL) -c "$$*"; do echo -e "Waiting for '$@'. $$(( $$(date +%s) - $$(stat -c %Y $@.w) )) seconds." && sleep 4; done && rm -f $@.w; } && wt

var/archlinux-base : var/id_ed25519
	mkdir -p $@.d
	wget -qcO $@.qcow2 https://repo.miserver.it.umich.edu/archlinux/images/latest/Arch-Linux-x86_64-basic.qcow2
	guestmount -a $@.qcow2 -i $@.d
	cp $<.pub $@.d/root/.ssh/authorized_keys
	echo archlinux-base > $@.d/etc/hostname
	echo -e "set -o vi\nalias ll='ls -l'\nalias vi=vim" > $@.d/root/.bash_profile
	guestunmount $@.d
	$(Wait) ! fuser $@.qcow2
	touch $@

var/id_ed25519 :
	mkdir -p $(@D)
	ssh-keygen -t ed25519 -C "$$PWD" -f $@ -N ""

var/daiker :
	mkdir -p $(@D)
	wget -qcO $@.tmp https://raw.githubusercontent.com/daimh/daiker/master/daiker
	chmod +x $@.tmp
	mv $@.tmp $@
