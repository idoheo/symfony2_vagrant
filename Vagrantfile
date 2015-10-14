# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end
  
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80   , host: 8080
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.100.254"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./vagrant", "/vagrant", disabled: false
  config.vm.synced_folder "./vagrant_assets", "/vagrant_assets", disabled: false, create: true
  if OS.windows? then
	config.vm.synced_folder "./vagrant_source", "/opt/dev-site/source", disabled: false, create: true, type: "smb", smb_host:"192.168.100.1"
  else
    config.vm.synced_folder "./vagrant_source", "/opt/dev-site/source", disabled: false, create: true, type: "nfs"
  end
  
  config.vm.provision "shell",
    inline: "chmod u+x /vagrant/provision-once.sh && /vagrant/provision-once.sh",
	run: "once"
	
  config.vm.provision "shell",
    inline: "chmod u+x /vagrant/provision-always.sh && /vagrant/provision-always.sh",
	run: "always"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  
  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    vb.gui = false
  
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
end
