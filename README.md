# Guide to Storage Operations in Bash

This guide breaks down a Bash script that offers various storage operations. It covers functionalities to display, create, remove, extend, and reduce storage entities like disks, partitions, and volumes on Linux systems.

## Table of Contents
1. [Display Operations](#display-operations)
2. [Create Operations](#create-operations)
3. [Remove Operations](#remove-operations)
4. [Extend Operations](#extend-operations)
5. [Reduce Operations](#reduce-operations)

---

## Display Operations

### List Available Disks and Partitions
```bash
lsblk
```
This command lists all available disks and partitions.

### List Available Physical Volumes
```bash
pvs
```
This command shows all physical volumes.

### List Available Volume Groups
```bash
vgs
```
This command lists all volume groups.

### List Available Logical Volumes
```bash
lvs
```
This command shows all logical volumes.

### List Available Filesystems and Mount Points
```bash
df -h
```
This command lists all file systems and their mount points.

---

## Create Operations

### Partition Disk
```bash
disk_name=/dev/sdb
fdisk $disk_name
partprobe
```
These commands create a new partition on the specified disk (/dev/sdb).

### Create Physical Volume
```bash
part_name=/dev/sdb1
pvcreate $part_name
```
This command creates a new physical volume.

### Create Volume Group
```bash
vg_name=vg-alpha
pv_name_1=/dev/sdb1;pv_name_2=;pv_name_3=
vgcreate $vg_name $pv_name_1 $pv_name_2 $pv_name_3
```
These commands create a new volume group named vg-alpha.

### Create Logical Volume
```bash
lv_name=hercule
vg_name=vg-alpha
lv_size=2G
lvcreate -n $lv_name -L $lv_size $vg_name
```
This command creates a new logical volume named hercule.

---

## Remove Operations

### Remove Mount Point
```bash
mount_path=/mnt/mountpoint
umount $mount_path
```
This command unmounts the specified mount point.

### Remove Logical Volume
```bash
lv_name=hercule
vg_name=vg-alpha
lvremove /dev/$vg_name/$lv_name
```
This command removes the specified logical volume.

### Remove Volume Group
```bash
vg_name=vg-alpha
vgremove $vg_name
```
This command removes the specified volume group.

### Remove Physical Volume
```bash
part_name=/dev/sdb1
pvremove $part_name
```
This command removes the specified physical volume.

### Remove Partition
```bash
disk_name=/dev/sdb
fdisk $disk_name
partprobe
```
These commands remove a partition from a disk.

---

## Extend Operations

### Extend Volume Group
```bash
vg_name=vg-alpha
new_part_name=/dev/sdb2
vgextend $vg_name $new_part_name
```
This command extends the volume group by adding a new partition to it.

### Extend Logical Volume
```bash
lv_name=hercule
vg_name=vg-alpha
extra_size=300M
lvextend -L +$extra_size /dev/$vg_name/$lv_name
```
This command extends the logical volume by a specified size.

### Extend Filesystem
```bash
mount_path=/mnt/mountpoint
lv_name=hercule
vg_name=vg-alpha
resize2fs /dev/$vg_name/$lv_name
```
This command extends the filesystem to utilize the newly added space in the logical volume.

---

## Reduce Operations

### Reduce Filesystem
```bash
new_fs_size=10GB
e2fsck -ff /dev/$vg_name/$lv_name
resize2fs /dev/$vg_name/$lv_name $new_fs_size
```
This command reduces the filesystem to a specified size.

### Reduce Logical Volume
```bash
lv_name=hercule
vg_name=vg-alpha
size_to_reduce=8G
lvreduce -L -$size_to_reduce /dev/$vg_name/$lv_name
```
This command reduces the logical volume by a specified size.

### Reduce Volume Group
```bash
vg_name=vg-alpha
part_name=/dev/sdb2
vgreduce $vg_name $part_name
```
This command removes a physical volume from a volume group, effectively reducing its size.

