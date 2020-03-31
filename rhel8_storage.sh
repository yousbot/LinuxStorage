#!/bin/bash

#########       DISPLAY       #########

## List available disks & partitions
lsblk
## Lit available physical volume 
pvs
## List available volume groups 
vgs
## List available logical volumes
lvs
## List available FS & MP
df -h 

#########       CREATE       #########

## Parition disk
disk_name=/dev/sdb
fdisk $disk_name
partprobe

## Create physical volume
part_name=/dev/sdb1
pvcreate $part_name

## Create a volume group
vg_name=vg-alpha
pv_name_1=/dev/sdb1;pv_name_2=;pv_name_3=
vgcreate $vg_name $pv_name_1 $pv_name_2 $pv_name_3

## Create a logical Volume
lv_name=hercule
vg_name=vg-alpha
lv_size=2G
lvcreate -n $lv_name -L $lv_size $vg_name

## Create a filesystem
fs_type=xfs
vg_name=vg-alpha
mkfs -t $fs_type /dev/$vg_name/$lv_name

## Create a mount point
mount_path=/mnt/mountpoint
vg_name=vg-alpha
lv_name=hercule
fs_type=xfs

mkdir -p $mount_path
echo "/dev/$vg_name/$lv_name $mount_path $fs_type defaults 1 2" >> /etc/fstab
mount $mount_path

#########       REMOVE       #########

## Remove a mount point
mount_path=/mnt/mountpoint
umount $mount_path

## Remove a logical volume
lv_name=hercule
vg_name=vg-alpha
lvremove /dev/$vg_name/$lv_name

## Remove a volume group
vg_name=vg-alpha
vgremove $vg_name

## Remove a physical volume
part_name=/dev/sdb1
pvremove $part_name

## Remove a partition
disk_name=/dev/sdb
fdisk $disk_name
partprobe

#########       EXTEND       #########

## Extend a volume group
vg_name=vg-alpha
new_part_name=/dev/sdb2         ## make sure you create the partition before
vgextend $vg_name $new_part_name

## Extend a logical volume
lv_name=hercule
vg_name=vg-alpha
extra_size=300M
lvextend -L +$extra_size /dev/$vg_name/$lv_name        ## Make sure u have extra space on the LV

## Extend a Filesystem
mount_path=/mnt/mountpoint
lv_name=hercule
vg_name=vg-alpha
resize2fs /dev/$vg_name/$lv_name

#########       REDUCE       #########

## Reduce a Filesystem
new_fs_size=10GB
e2fsck -ff /dev/$vg_name/$lv_name
resize2fs /dev/$vg_name/$lv_name $new_fs_size

## Redice a logical volume
lv_name=hercule
vg_name=vg-alpha
size_toreduce=8G
lvreduce -L -$size_toreduce /dev/$vg_name/$lv_name 

## Reduce a volume group
vg_name=vg-alpha
part_name=/dev/sdb2
vgreduce $vg_name $part_name

