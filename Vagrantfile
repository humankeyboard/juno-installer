# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'config'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false

  DEST = "~"

  config.vm.provider "virtualbox" do |v, override|
    v.gui = false
    override.vm.box = "trusty"
  end    

  config.vm.define "orchestration" do |master|
    master.vm.hostname = "orchestration"

    master.vm.network :private_network, ip:"10.0.0.10", :netmask => "255.255.255.0"    


    # install salt-master, salt-minon    
    master.vm.provision :salt do |salt|
      # see options here: https://github.com/saltstack/salty-vagrant/blob/develop/example/complete/Vagrantfile

      salt.install_master = true
      salt.install_type = "stable"
    
      salt.minion_config = "salt/minion"
      salt.master_config = "salt/master"

      salt.minion_key = "salt/minion.pem"
      salt.minion_pub = "salt/minion.pub"

      salt.master_key = "salt/master.pem"
      salt.master_pub = "salt/master.pub"
    end

    # disable StrictHostKeyChecking for github
    master.vm.provision "file",
      source: "etc/ssh-config",
      destination: "#{DEST}/.ssh/config"

    # copy my private key so I can checkout from private repo
    master.vm.provision "file", 
      source: "#{HOME}/.ssh/id_rsa", 
      destination: "#{DEST}/.ssh/id_rsa"

    # copy my public key
    master.vm.provision "file", 
      source: "#{HOME}/.ssh/id_rsa.pub",
      destination: "#{DEST}/.ssh/id_rsa.pub"

    # change ownership of /srv to vagrant 
    master.vm.provision "shell", inline: "chown vagrant:vagrant /srv"

    # ensure git is installed
    master.vm.provision "shell", inline: "apt-get install git -y"

    # clone salt-sandbox environment
    master.vm.provision "shell", inline: "git clone https://github.com/saltstackme/salt-sandbox.git /srv/salt-sandbox", privileged: false

    # clone given forked repo environment
    master.vm.provision "shell", inline: "git clone #{REPO} /srv/salt", privileged: false

    # set github username
    master.vm.provision "shell", inline: "git config --global user.name #{GITHUB_USERNAME}", privileged: false

    # set github e-mail address
    master.vm.provision "shell", inline: "git config --global user.email #{GITHUB_EMAIL}", privileged: false

    # create a temporary minion configuration for masterless execution
    master.vm.provision "file", 
      source: "salt/minion-masterless",
      destination: "/tmp/salt/minion"

    # run salt-sandbox formulas to configure salt-master
    master.vm.provision "shell", inline: "salt-call --local -c /tmp/salt state.highstate -l quiet"
  end

  config.vm.define "controller" do |node|
    node.vm.box = "trusty"
    node.vm.hostname = "controller"
    node.vm.network :private_network, ip:"10.0.0.11", :netmask => "255.255.255.0"

    node.vm.provision :salt do |salt|
      # see options here: https://github.com/saltstack/salty-vagrant/blob/develop/example/complete/Vagrantfile
      salt.install_master = false
      salt.install_type = "stable"
      salt.minion_config = "salt/minion"
      salt.minion_key = "salt/minion.pem"
      salt.minion_pub = "salt/minion.pub"
    end

  end

  config.vm.define "network" do |node|
    node.vm.box = "trusty"
    node.vm.hostname = "network"
    node.vm.network :private_network, ip:"10.0.0.21", :netmask => "255.255.255.0"
    node.vm.network :private_network, ip:"10.0.1.21", :netmask => "255.255.255.0"

    node.vm.provision :salt do |salt|
      salt.install_master = false
      salt.install_type = "stable"
      salt.minion_config = "salt/minion"
      salt.minion_key = "salt/minion.pem"
      salt.minion_pub = "salt/minion.pub"
    end

  end

  config.vm.define "compute" do |node|
    node.vm.box = "trusty"
    node.vm.hostname = "compute1"
    node.vm.network :private_network, ip:"10.0.0.31", :netmask => "255.255.255.0"
    node.vm.network :private_network, ip:"10.0.1.31", :netmask => "255.255.255.0"

    node.vm.provision :salt do |salt|
      salt.install_master = false
      salt.install_type = "stable"
      salt.minion_config = "salt/minion"
      salt.minion_key = "salt/minion.pem"
      salt.minion_pub = "salt/minion.pub"
    end

  end

end
