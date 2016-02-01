
apt_repository 's3fs' do
  uri 'http://ppa.launchpad.net/apachelogger/s3fs-fuse/ubuntu'
  distribution 'trusty'
  components ['main']
  action :add
  key '4427DF3B'
  keyserver 'keyserver.ubuntu.com'
  deb_src true
  notifies :run, 'execute[apt-get update]', :immediately
end

# S3 Fuse FS
package 's3fs-fuse' do
    action :install
end

file '/root/.passwd-s3fs' do
  content "#{node['aws']['aws_access_key_id']}:#{node['aws']['aws_secret_access_key']}"
  mode '0400'
  owner 'root'
  group 'root'
end

directory '/tmp/cache' do
  owner 'root'
  group 'root'
  mode '0777'
  recursive true
  action :create
end

mount "/home/#{node['vagrant']['user']}/logs" do
  device "s3fs##{node['aws']['s3_bucket']}"
  fstype "fuse"
  options "allow_other,use_cache=/tmp/cache"
  dump 0
  pass 0
  action [:mount, :enable]
  not_if "grep -qs '/logs ' /proc/mounts"
end

file "/home/#{node['vagrant']['user']}/logs/Deposez-ici.md" do
  content '# Oui c\'est dans ce répertoire que vous devez déposer vos logs svp'
  mode '0644'
  owner 'root'
  group 'root'
end
