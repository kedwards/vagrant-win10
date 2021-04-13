#!/usr/bin/env bash

# switch into default VirtualBox directory
cd ~/VirtualBox\ VMs/

# create new VirtualBox VM
VBoxManage createvm --name "Win10x64" --ostype Windows10_64 --register

# configure system settings of VM
VBoxManage modifyvm "Win10x64" --memory 2048 --cpus 2 --acpi on --pae on --hwvirtex on --nestedpaging on

# configure boot settings of VM
VBoxManage modifyvm "Win10x64" --boot1 dvd --boot2 disk --boot3 none --boot4 none

# configure video settings
VBoxManage modifyvm "Win10x64" --vram 128 --accelerate3d on

# configure audio settings
VBoxManage modifyvm "Win10x64" --audio coreaudio --audiocontroller hda

# configure network settings
VBoxManage modifyvm "Win10x64" --nic1 nat

# configure usb settings
VBoxManage modifyvm "Win10x64" --usb on

# create storage medium for VM
VBoxManage createhd --filename ./Win10x64/Win10x64.vdi --size 30000

# modify a storage controller
VBoxManage storagectl "Win10x64" --name "SATA" --add sata

# attache storage medium to VM
VBoxManage storageattach "Win10x64" --storagectl "SATA" --port 0 --device 0 --type hdd --medium ./Win10x64/Win10x64.vdi

# add windows iso
VBoxManage storageattach "Win10x64" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium ~/iso/windows.iso

# add guest addition iso
VBoxManage storageattach "Win10x64" --storagectl "SATA" --port 2 --device 0 --type dvddrive --medium /path/to/VBoxGuestAdditions.iso

# start VM
VBoxManage startvm Win10x64

# remove media (on stopped VM)
# VBoxManage storageattach "Win10x64" --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium none
# VBoxManage storageattach "Win10x64" --storagectl "SATA" --port 2 --device 0 --type dvddrive --medium none

#curl "https://vagrantcloud.com/api/v1/box/kevinedwards/windows10/version/1.2.0/provider/virtualbox/upload?access_token=${VAGRANT_TOKEN}"