apache_download_location = "#{node['nc4']['nexus']['url']}#{node['nc4']['apache-httpd-32']['version']}#{node['nc4']['apache-httpd-32']['package']}"

remote_file "Download Apache Module from nexus" do
  source apache_download_location
  notifies :run "execute[Unzip Apache package]", :immediately
#  not_if {file.directory?('D:\NC4\MC3')}
end

execute "Unzip Apache package" do
  command 'cd #node{['nc4']['apache']['install_location']}'
  command 'unzip #{node['nc4']['apache-httpd-32']['package']} #node{['nc4']['apache']['workdir']}'
  notifies :run "execute[Remove Logs]", :immediately
end

execute "Remove Logs" do
  command 'cd #node{['nc4']['apache']['workdir']}'
  command 'RD /S /Q #node{['nc4']['apache']['logdir']}'
  command 'RD /S /Q #node{#node{['nc4']['apache']['workdir']}\errors'
end

file 'D:\NC4\MC3\HTTPD\conf\extra\MC3AgileDev.conf' do
  source 'httpd-vhosts.conf'
end

template 'D:\NC4\MC3\HTTPD\conf\httpd.conf' do
  source 'httpd.erb'
  variables( :server_name => 'MC3AgileDev')
end

execute 'Create Windows service for Apache' do
  command 'cd D:\NC4\HTTPD\bin'
  command 'httpd.exe -k install -n "Apache 2.2 HTTP"'
  command 'sc \\server config ServiceName obj= Domain\user password= pass'
end
