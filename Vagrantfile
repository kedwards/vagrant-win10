# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "windows10base"
  #config.vm.box = "kevinedwards/windows10x64"
  #config.vm.box_version = "1.1.3"
  config.vm.boot_timeout = 600
  config.vm.guest = :windows

  config.vm.communicator = "winrm"
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"

  config.winrm.timeout = 180
    
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.extra_args = "cmd"  # cmd or powershell

  config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
  config.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    vb.memory = "3072"
    vb.cpus = 2
    vb.name = "Windows 10"
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--cpus", 2]
    vb.customize ["modifyvm", :id, "--vram", 128]
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "on"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]        
  end

  # sudo VBoxManage list usbhost
  # config.vm.provider "virtualbox" do |vb|
  #   vb.customize ["usbfilter", "add", "0",
  #     "--target", :id,
  #     "--name", "Any Expressif Board",
  #     "--product", "Dual RS232-HS",
  #     '--vendorid', "0x0403",
  #     "--productid", "0x6010"
  #   ]
  # end
end

