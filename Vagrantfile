# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify minimum Vagrant version 
Vagrant.require_version ">= 1.6.0"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# http://stackoverflow.com/questions/19492738/demand-a-vagrant-plugin-within-the-vagrantfile
# vagrant plugin list
required_plugins = %w( vagrant-aws vagrant-aws-route53 vagrant-omnibus vagrant-berkshelf)
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

# Require YAML module
require 'yaml'

# Read YAML file with box details usable like : servers["variable_name"]
settings = YAML.load_file('settings.yaml')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 
  # Provider default order
  config.vm.provider "aws"
  config.vm.provider "virtualbox"

  # No provider specific 
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/", rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "--delete", "-z"]

  ####### Virtualbox #######
  config.vm.provider "virtualbox" do |vb, override|
  override.ssh.username = settings['vb']['ssh_username']
    config.vm.box = settings['vb']['vm_box']
    config.vm.box_url = settings['vb']['vm_box_url']
    config.vm.post_up_message = settings['vagrant']['motd']
    override.vm.box_check_update = settings['vb']['vm_box_check_update']
    override.vm.network :forwarded_port, guest: 21, host: 8181, auto_correct: true
    override.vm.network "private_network", type: "dhcp"
    vb.customize ["modifyvm", :id, "--memory", settings['vb']['mem']]
    vb.customize ["modifyvm", :id, "--cpus", settings['vb']['cpus']]
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
  end

  ####### AWS #######
  config.vm.provider :aws do |aws, override|
    override.vm.box = settings['aws']['vm_box']
    override.vm.box_url = settings['aws']['vm_box_url']
    aws.access_key_id = settings['aws']['aws_access_key_id']
    aws.secret_access_key = settings['aws']['aws_secret_access_key']
    aws.region = settings['aws']['aws_region']
    aws.region_config settings['aws']['aws_region'] do |region|
      # Ubuntu 14.04.3 LTS (Trusty Tahr)
      region.ami = settings['aws']['aws_region_ami']
      region.keypair_name = settings['aws']['aws_keypair_name']
    end
    aws.monitoring = settings['aws']['aws_monitoring']
    aws.elastic_ip = settings['aws']['aws_elastic_ip']
    aws.associate_public_ip = settings['aws']['aws_associate_public_ip']
    aws.instance_ready_timeout = settings['aws']['aws_instance_ready_timeout']
    aws.instance_type = settings['aws']['aws_instance_type']  
    aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 10 }]
    aws.security_groups = settings['aws']['aws_security_groups'] 
    aws.tags = {
      'Name' => settings['vagrant']['hostname'] + settings['vagrant']['domain'],
      'Vagrant' => 'true',
      'Owner' => settings['vagrant']['owner'],
      'user' => settings['vagrant']['user']
    }
    override.ssh.username = settings['aws']['ssh_username']
    override.ssh.private_key_path = settings['aws']['ssh_private_key_path']
    override.route53.hosted_zone_id = settings['aws']['route53_hosted_zone_id']
    override.route53.record_set = %W[#{settings['vagrant']['hostname'] + settings['vagrant']['domain']}. A]
  end

  ##### Provisioner Shell / Chef / Puppet #####
  # The issue arises because Ubuntu's default /root/.profile contains a line that prevents messages from being written to root's console by other users. This "mesg n" command fails because it is expecting to be run from an interactive terminal (a tty) and not a script.
  config.vm.provision "fix-no-tty", type: "shell" do |command|
    command.privileged = false
    command.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  # Ensures that Chef is installed, using the Vagrant Omnibus plugin.
  config.omnibus.chef_version = :latest

  # Enable Berkshelf for Vagrant https://github.com/berkshelf/vagrant-berkshelf
  # http://stackoverflow.com/questions/20269623/how-to-use-hand-written-cookbooks-when-using-berkshelf-in-chef
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    #chef.data_bags_path = "data_bags"
    chef.cookbooks_path = "cookbooks"
    # chef.log_level = :debug
    chef.json = {
        "vagrant" => {
            "user" => "#{settings['vagrant']['user']}",
            "user_password" => "#{settings['vagrant']['user_password']}",
            "hostname" => "#{settings['vagrant']['hostname']}",
            "domain" => "#{settings['vagrant']['domain']}"
        },
        "aws" => {
            "aws_access_key_id" => "#{settings['aws']['aws_access_key_id']}",
            "aws_secret_access_key" => "#{settings['aws']['aws_secret_access_key']}",
            "s3_bucket" => "#{settings['aws']['s3_bucket']}"
        }
    }
    # Order is important
    chef.add_recipe "apt"
    chef.add_recipe "misc::default"
    chef.add_recipe "misc::user"
    chef.add_recipe "misc::s3fs"
    chef.add_recipe "misc::vsftpd"
  end
end