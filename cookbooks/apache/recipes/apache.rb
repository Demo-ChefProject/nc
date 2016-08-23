
#apache_download_location = "#{node['nc4']['nexus']['url']}#{node['nc4']['apache-httpd-32']['version']}#{node['nc4']['apache-httpd-32']['package']}"
apache_download_location = "http://54.175.158.124:8081/repository/Rigil/apache-httpd-32-2.2.32.zip"
apache_server_name = node['nc4']['server_name']
apache_work_dir = node['nc4']['apache']['workdir']
apache_httpd_conf = node['nc4']['apache-conf']['location']

# remote_file "Download Apache Module from nexus" do
remote_file "C:/NC4/MC3/apache-httpd-32-2.2.2.32.zip" do
  source apache_download_location
  action :create
  notifies :run, 'powershell_script[Unzip Apache package]', :immediately
  #not_if {file.directory?('D:\NC4\MC3')}
end

powershell_script 'Unzip Apache package' do
  code <<-EOH
  Remove-Item "#{apache_work_dir}" -recurse
  powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('C:/NC4/MC3/apache-httpd-32-2.2.2.32.zip', 'C:/NC4/MC3'); }"
  EOH
#  only_if "Dir.exist?(#node{['nc4']['apache']['workdir']})"
  notifies :run, 'powershell_script[Remove Logs]', :immediately
end

powershell_script 'Remove Logs' do
  guard_interpreter :powershell_script
  code <<-EOH
  Remove-Item "#{node['nc4']['apache']['workdir']}/error" -recurse
  EOH
  only_if "Dir.exist?(#{node['nc4']['apache']['workdir']}/error')"

  code <<-EOH
  Remove-Item "#{node['nc4']['apache']['workdir']}/logs" -recurse
  EOH
  only_if "Dir.exist?(#{node['nc4']['apache']['workdir']}/logs)"
end

#file 'C:\\NC4\\MC3\\HTTPD\\conf\\extra\\MC3AgileDev.conf' do
      #file '#node{["nc4"]["mc3agiledev-conf"]["url"]}'   do
#  path "C:\\NC4\\MC3\\HTTPD\\conf\\extra\\MC3AgileDev.conf"
# action :create
#end

template "#{apache_httpd_conf}/httpd-vhost.conf" do
  source 'httpd-vhosts.conf.erb'
  variables( :server_name => apache_server_name )
  action :create
end

template "#{apache_httpd_conf}/httpd.conf" do
  source 'httpd.conf.erb'
  variables({ 
    :server_name => apache_server_name,
    :work_dir => apache_work_dir
    })
  action :create
end

powershell_script 'delete_if_exist' do
  code <<-EOH
     $Service = Get-WmiObject -Class Win32_Service -Filter "Name='Apache 2.2 HTTP'"
     if ($Service) {
        $Service.Delete() 
     }
  EOH
  notifies :run, 'execute[Installing Service Apache]', :immediately
end

execute 'Installing Service Apache' do
  command "echo sc create 'Apache 2.2 HTTP' binPath= #{node['nc4']['apache']['bindir']}/httpd.exe"
  action :nothing
end