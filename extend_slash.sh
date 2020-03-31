#!/bin/bash

##  Prerequisites 
##  1.  Add a new disk 
##  2.  Create a new partition on the disk 
##         fdisk /dev/sdX

extend_slash()
{
    part_name=$1     
    extra_size=$2        

    echo " Existing size : $(df -h | grep "mapper") "; echo"";
    pvcreate $part_name
    echo " Physical volume extended ..."
    vgextend rhel $part_name
    echo " Volume group extended ... "
    lvextend -L +$extra_size /dev/rhel/root
    echo " Logical volume extended ..."
    partprobe
    echo " Partition written to kernel ..."
    xfs_growfs /
    echo " /dev/rhel/root filesystem extended ..." 
    echo " NEW size : $(df -h | grep "mapper") "; echo " ";
    echo " Operation completed !"
}


## MAIN

    echo "";
    read -p " Did you created a new partition ?  [ y,n ] " doit; echo " ";

if [[ $doit == "Y" || $doit == "y" ]]; then


    read -p " Enter the partition name [ Ex : /dev/sdb1 ] : " part_name; echo " ";
    read -p " Enter the size to add to / [ Ex : 800MB, 1GB ... ] : " extra_size; echo " ";

    ## Extend slash
    extend_slash $part_name $extra_size


else
        echo " Exiting ... "
        exit
fi




