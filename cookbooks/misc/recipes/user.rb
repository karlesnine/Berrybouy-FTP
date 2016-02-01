psw = `openssl passwd -1 -salt saltphrase #{node['vagrant']['user_password']}`

user node['vagrant']['user'] do
    comment 'user'
    password psw[0...-1]
    home "/home/#{node['vagrant']['user']}/logs"
    supports :manage_home=>false
    shell "/bin/false"
end

directory "/home/#{node['vagrant']['user']}/logs" do
  mode '0777'
  recursive true
  action :create
end