apache_download_location = "#{node['nc4']['nexus']['url']}#{node['nc4']['apache-httpd-32']['version']}#{node['nc4']['apache-httpd-32']['package']}"

# remote_file "Download Apache Module from nexus" do
  #source apache_download_location
remote_file 'C:/NC4/MC3/apache-httpd-32-2.2.2.32.zip' do
  source 'http://54.175.158.124:8081/repository/Rigil/apache-httpd-32-2.2.32.zip'
  action :create
  notifies :run, 'execute[Unzip Apache package]', :immediately
  #notifies :run, 'execute[create-yum-cache]', :immediately
  #not_if {file.directory?('D:\NC4\MC3')}
end

powershell_script 'Unzip Apache package' do
  code <<-EOH
  Remove-Item C:\\NC4\\MC3\\HTTPD -recurse
  powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('C:/NC4/MC3/apache-httpd-32-2.2.2.32.zip', 'C:/NC4/MC3'); }"
  EOH
  notifies :run, "powershell_script[Remove Logs]", :immediately
end

powershell_script 'Remove logs' do
  code <<-EOH
  Remove-Item C:\\NC4\\MC3\\HTTPD\\error -recurse
  Remove-Item C:\\NC4\\MC3\\HTTPD\\logs -recurse
  EOH
end

#execute "Unzip Apache package" do
  #command 'cd C:\Program Files\7-Zip'
  #command 'powershell.exe -nologo -noprofile -command "&{ Add-Type -A "System.IO.Compression.FileSystem"; [IO.Compression.ZipFile]::ExtractToDirectory("apache-httpd-32-2.2.32.zip", "C:\\NC4\\MC3\\"); }" '
  #command 'unzip #{node["nc4"]["apache-httpd-32"]["package"]} #node{["nc4"]["apache"]["workdir"]}'
  #notifies :run, "execute[Remove Logs]", :immediately
#end

#execute "Remove Logs" do
  #command 'cd #node{["nc4"]["apache"]["workdir"]}'
  #command 'RD /S /Q #node{["nc4"]["apache"]["logdir"]}'
  #command 'RD /S /Q #node{["nc4"]["apache"]["workdir"]}\errors'
#end


#file 'C:\NC4\MC3\HTTPD\conf\extra\MC3AgileDev.conf' do
#file '#node{["nc4"]["mc3agiledev-conf"]["url"]}'   do
  #source "httpd-vhosts.conf"
#  action :'#node{["nc4"]["httpd-vhost-conf"]["url"]}'
#  action :create
#end

#template 'D:\NC4\MC3\HTTPD\conf\httpd.conf' do
template 'C:\NC4\MC3\HTTPD\conf\httpd.conf' do
  source 'httpd-conf.erb'
  #source '#node{["nc4"]["httpd-erb"]["url"]}'
  variables( :server_name => 'MC3AgileDev')
end

execute 'Create Windows service for Apache' do
  #command 'cd D:\NC4\HTTPD\bin'
  command 'cd #node{["nc4"]["apache"]["bindir"]}'
  command 'httpd.exe -k install -n "Apache 2.2 HTTP"'
  command 'sc \\\\server config ServiceName obj= Domain\user password= pass'
end
