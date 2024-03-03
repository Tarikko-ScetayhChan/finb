#!/bin/sh

####### gentooarm64installchroot.sh

##### Read and edit this script before you chmod +x and run it.

mount /dev/nvme0n1p4 --mkdir /mnt/gentoo && mount /dev/nvme0n1p2 --mkdir /mnt/gentoo/boot && mount /dev/nvme0n1p1 --mkdir /mnt/gentoo/boot/efi && swapon /dev/nvme0n1p3 && mount --types proc /proc /mnt/gentoo/proc && mount --rbind /sys /mnt/gentoo/sys && mount --make-rslave /mnt/gentoo/sys && mount --rbind /dev /mnt/gentoo/dev && mount --make-rslave /mnt/gentoo/dev && mount --bind /run /mnt/gentoo/run && mount --make-slave /mnt/gentoo/run && chroot /mnt/gentoo /bin/bash