execute 'apt-get update' do
  command 'apt-get update --fix-missing -y'
  only_if { apt_installed? }
  action :run
end

# Automatically remove packages that are no longer needed for dependencies
execute 'apt-get autoremove' do
  command 'apt-get -y autoremove'
  only_if { apt_installed? }
  action :run
end

# Automatically remove .deb files for packages no longer on your system
execute 'apt-get autoclean' do
  command 'apt-get -y autoclean'
  only_if { apt_installed? }
  action :run
end

# Less tools:
%w( mc laptop-detect sl nano mtr puppet ).each do |pkg|
  package pkg do
    action :purge
  end
end

# More tools ?: moreutils iftop iotop lsof 
%w( curl htop mtr-tiny ncdu
  screen sysstat tcpdump tmux tree vim
  wget s3cmd zip unzip ).each do |pkg|
  package pkg do
    action :install
  end
end