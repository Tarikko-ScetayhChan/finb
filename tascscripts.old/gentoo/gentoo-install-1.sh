#!/bin/bash

set -e

echo -e "-----------------------------------------------------\n|                   \e[1mtascscripts\e[0m                     |\n|        Copyright 2024 Tarikko-ScetayhChan         |\n|https://github.com/Tarikko-ScetayhChan/tascscripts/|\n-----------------------------------------------------\n-----------------------------------------------------\n|                gentoo-install-1.sh                |\n-----------------------------------------------------\nThis file is part of tascscripts.\ntascscripts is free software: you can redistribute it\nand/or modify it under the terms of the GNU General\nPublic License as published by the Free Software\nFoundation, either version 3 of the License, or (at\nyour option) any later version.\ntascscripts is distributed in the hope that it will\nbe useful, but WITHOUT ANY WARRANTY; without even the\nimplied warranty of MERCHANTABILITY or FITNESS FOR A\nPARTICULAR PURPOSE. See the GNU General Public\nLicense for more details.\nYou should have received a copy of the GNU General\nPublic License along with tascscripts. If not, see\n<https://www.gnu.org/licenses/>.\n"; sleep 5

echo -e "\e[33mWarning: \e[0mConnect to the internet before running this\nscript.\n"; sleep 5

echo -e "\e[33mWarning: \e[0mEdit '${PATH_SCRIPTS_ROOT}/env/gentoo-install-env.conf'\nbefore running this script.\n"; sleep 5

echo -e "\e[33mWarning: \e[0mYou will have 5 seconds to cancel this\nscript."; sleep 1; echo "5"; sleep 1; echo "4"; sleep 1; echo "3"; sleep 1; echo "2"; sleep 1; echo "1"; sleep 1

echo -e "\n\e[32m==> Step 1 of 20: \e[0mTo set the environment variables\n"; sleep 1
export PATH_SCRIPTS_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" &&
echo -e "PATH_SCRIPTS_ROOT=${PATH_SCRIPTS_ROOT}";
source ${PATH_SCRIPTS_ROOT}/env/gentoo-install-env.conf &&
echo -e "\e[32m\n${PATH_SCRIPTS_ROOT}/env/gentoo-install-env.conf\n-----------------------------------------------------\e[0m";
cat -n ${PATH_SCRIPTS_ROOT}/env/gentoo-install-env.conf;
echo -e "\n\e[32m-----------------------------------------------------\e[0m";

echo -e "\n\e[32m==> Step 2 of 20: \e[0mnet-setup\n"; sleep 1
net-setup &&

echo -e "\n\e[32m==> Step 3 of 20: \e[0mTo back up '/etc/resolv.conf'\n"; sleep 1
cp -v /etc/resolv.conf{,.bak};

echo -e "\n\e[32m==> Step 4 of 20: \e[0mTo replace nameserver in '/etc/resolv.conf'\n"; sleep 1
sed -i --debug "s|nameserver.*|nameserver ${nameserver}|g" /etc/resolv.conf &&
echo -e "\e[32m\n/etc/resolv.conf\n-----------------------------------------------------\e[0m";
cat -n /etc/resolv.conf;
echo -e "\n\e[32m-----------------------------------------------------\e[0m";

echo -e "\n\e[32m==> Step 5 of 20: \e[0mTo generate the fdisk script\n"; sleep 1
mkdir -v ${PATH_SCRIPTS_ROOT}/tmp &&
echo -e "g\nn\n1\n\n+${size_efi_parition}\nt\n1\nn\n2\n\n+${size_boot_parition}\nn\n3\n\n+${size_swap_parition}\nn\n4\n\n\nw" > ${PATH_SCRIPTS_ROOT}/tmp/gentoo-install-fdisk.txt &&
echo -e "\e[32m\n${PATH_SCRIPTS_ROOT}/tmp/gentoo-install-fdisk.txt\n-----------------------------------------------------\e[0m";
cat -n ${PATH_SCRIPTS_ROOT}/tmp/gentoo-install-fdisk.txt;
echo -e "\n\e[32m-----------------------------------------------------\e[0m";

echo -e "\n\e[32m==> Step 6 of 20: \e[0mTo partition the disk\n"; sleep 1
cat ${PATH_SCRIPTS_ROOT}/tmp/gentoo-install-fdisk.txt | fdisk ${path_disk} &&

echo -e "\n\e[32m==> Step 7 of 20: \e[0mTo create file systems\n"; sleep 1
mkfs.fat -F 32 ${path_efi_parition} &&
mkfs.${fs_boot_parition} ${path_boot_parition} &&
mkswap ${path_swap_parition} &&
mkfs.${fs_root_parition} ${path_root_parition} &&

echo -e "\n\e[32m==> Step 8 of 20: \e[0mTo mount file systems\n"; sleep 1
mount -v ${path_root_parition} --mkdir /mnt/gentoo &&
mount -v ${path_boot_parition} --mkdir /mnt/gentoo/boot &&
mount -v ${path_efi_parition} --mkdir /mnt/gentoo/boot/efi &&
swapon -v ${path_swap_parition} &&

echo -e "\n\e[32m==> Step 9 of 20: \e[0mTo create swapfile\n"; sleep 1
fallocate -l ${size_swapfile} -v /mnt/gentoo/swapfile &&
chmod 600 /mnt/gentoo/swapfile &&
mkswap /mnt/gentoo/swapfile;

echo -e "\n\e[32m==> Step 10 of 20: \e[0mTo mount swapfile\n"; sleep 1
swapon /mnt/gentoo/swapfile;

echo -e "\n\e[32m==> Step 11 of 20: \e[0mTo set the date and the time\n"; sleep 1
hwclock -v --systohc;
date ${date}

echo -e "\n\e[32m==> Step 12 of 20: \e[0mTo enter '/mnt/gentoo'\n"; sleep 1
cd /mnt/gentoo &&
pwd;

echo -e "\n\e[32m==> Step 13 of 20: \e[0mTo download the stage file\n"; sleep 1
links ${address_stage3} &&

echo -e "\n\e[32m==> Step 14 of 20: \e[0mTo extract the stage file\n"; sleep 1
tar xpvf *.tar.xz --xattrs-include='*.*' --numeric-owner &&

echo -e "\n\e[32m==> Step 15 of 20: \e[0mTo copy the Gentoo repository configuration file\n"; sleep 1
mkdir -p -v /mnt/gentoo/etc/portage/repos.conf;
cp -v /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf &&

echo -e "\n\e[32m==> Step 16 of 20: \e[0mTo replace the sync-uri variable\n"; sleep 1
sed -i --debug "s|rsync:\/\/rsync.gentoo.org\/gentoo-portage|${address_rsync}|g" /mnt/gentoo/etc/portage/repos.conf/gentoo.conf &&
echo -e "\e[32m\n/mnt/gentoo/etc/portage/repos.conf/gentoo.conf\n-----------------------------------------------------\e[0m";
cat -n /mnt/gentoo/etc/portage/repos.conf/gentoo.conf;
echo -e "\n\e[32m-----------------------------------------------------\e[0m";

echo -e "\n\e[32m==> Step 17 of 20: \e[0mTo copy DNS info\n"; sleep 1
cp -v --dereference /etc/resolv.conf /mnt/gentoo/etc/ &&

echo -e "\n\e[32m==> Step 18 of 20: \e[0mTo mount the necessary filesystems\n"; sleep 1
mount -v --types proc /proc /mnt/gentoo/proc &&
mount -v --rbind /sys /mnt/gentoo/sys &&
mount -v --make-rslave /mnt/gentoo/sys &&
mount -v --rbind /dev /mnt/gentoo/dev &&
mount -v --make-rslave /mnt/gentoo/dev &&
mount -v --bind /run /mnt/gentoo/run &&
mount -v --make-slave /mnt/gentoo/run &&

echo -e "\n\e[32m==> Step 19 of 20: \e[0mTo copy scripts into the new root\n"; sleep 1
mkdir -v /mnt/gentoo/tascscripts;
cp -r -v ${PATH_SCRIPTS_ROOT}/../ /mnt/gentoo/tascscripts;

echo -e "\n\e[32m==> Step 20 of 20: \e[0mTo enter the new environment\n"; sleep 1
chroot /mnt/gentoo /bin/bash
