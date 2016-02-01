source 'https://supermarket.chef.io'

cookbook 'apt'
Dir['./cookbooks/**'].each do |path|
  cookbook File.basename(path), path: path
end