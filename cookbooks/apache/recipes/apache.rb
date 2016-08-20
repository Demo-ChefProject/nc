apache_download_location = "#{node['nc4']['nexus']['url']}#{node['nc4']['apache-httpd-32']['version']}#{node['nc4']['apache-httpd-32']['package']}"

remote_file "Download Apache Module from nexus" do
  source apache_download_location
  notifies :run, 'execute[Unzip Apache package]', :immediately
  #notifies :run, 'execute[create-yum-cache]', :immediately
#  not_if {file.directory?('D:\NC4\MC3')}
end

execute "Unzip Apache package" do
  command 'cd #node{["nc4"]["apache"]["install_location"]}'
  command 'unzip #{node["nc4"]["apache-httpd-32"]["package"]} #node{["nc4"]["apache"]["workdir"]}'
  notifies :run, "execute[Remove Logs]", :immediately
end

execute "Remove Logs" do
  command 'cd #node{["nc4"]["apache"]["workdir"]}'
  command 'RD /S /Q #node{["nc4"]["apache"]["logdir"]}'
  command 'RD /S /Q #node{["nc4"]["apache"]["workdir"]}\errors'
end


#file 'D:\NC4\MC3\HTTPD\conf\extra\MC3AgileDev.conf' do
file '#node{["nc4"]["mc3agiledev-conf"]["url"]}'   do
  #source 'httpd-vhosts.conf'
  source '#node{["nc4"]["httpd-vhost-conf"]["url"]}'
end

#template 'D:\NC4\MC3\HTTPD\conf\httpd.conf' do
template '#node{["nc4"]["httpd-conf"]["url"]}' do
  #source 'httpd.erb'
  source '#node{["nc4"]["httpd-erb"]["url"]}'
  owner "root"
  group "root"
  mode "066"
  variables( :server_name => 'MC3AgileDev')
end

execute 'Create Windows service for Apache' do
  #command 'cd D:\NC4\HTTPD\bin'
  command 'cd #node{["nc4"]["apache"]["bindir"]}'
  command 'httpd.exe -k install -n "Apache 2.2 HTTP"'
  command 'sc \\\\server config ServiceName obj= Domain\user password= pass'
end
