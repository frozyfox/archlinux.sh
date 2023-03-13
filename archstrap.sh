#!/bin/sh

USERNAME='user'

[ -z "$(which sudo)" ] && pacman -S sudo
[ -z "$(which dhcpcd)" ] && pacman -S dhcpcd
systemctl enable dhcpcd
useradd -mG wheel ${USERNAME}
sed -i /s.*%wheel/%wheel/ /etc/sudoers
passwd ${USERNAME}
[ -n "$(which aa-status)" ] && {
	systemctl enable apparmor
	awk /GRUB_CMDLINE.*DEFAULT/ {sub(/"$/, " lsm=apparmor apparmor=1\""); print} /etc/default/grub
}
grub-install --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
