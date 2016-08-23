
#apache_download_location = "#{node['nc4']['nexus']['url']}#{node['nc4']['apache-httpd-32']['version']}#{node['nc4']['apache-httpd-32']['package']}"
apache_download_location = "http://54.175.158.124:8081/repository/Rigil/apache-httpd-32-2.2.32.zip"
apache_server_name = node['nc4']['server_name']
apache_work_dir = "#{node['nc4']['apache']['install_location']}/HTTPD"
apache_httpd_conf = "#{apache_work_dir}/conf"

remote_file "Download Apache Module from nexus" do
  source apache_download_location
  action :create
  notifies :run, 'powershell_script[Unzip Apache package]', :immediately
end

powershell_script 'Unzip Apache package' do
  code <<-EOH
  Remove-Item #{apache_work_dir} -recurse
  powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('C:/NC4/MC3/apache-httpd-32-2.2.2.32.zip', 'C:/NC4/MC3'); }"
  EOH
  notifies :run, 'powershell_script[Remove logs folder]', :immediately
end


powershell_script 'Remove logs folder' do
  guard_interpreter :powershell_script
  code <<-EOH
    Remove-Item #{apache_work_dir}/logs/* -recurse
  EOH
  only_if do Dir.exist?("#{apache_work_dir}/logs") end
#  notifies :run, 'powershell_script[Remove error folder]', :immediately
end

#Commented out per feedback from Satvinder
#powershell_script 'Remove error folder' do
#  guard_interpreter :powershell_script
#  code <<-EOH
#    Remove-Item #{apache_work_dir}/error -recurse
#  EOH
#  only_if do Dir.exist?("#{apache_work_dir}/error") end
#end

cookbook_file "#{apache_httpd_conf}/extra/#{apache_server_name}.conf" do
  source 'server_name.conf'
  action :create
end

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

#powershell_script 'delete_if_exist' do
#  code <<-EOH
#     $Service = Get-WmiObject -Class Win32_Service -Filter 'Name="Apache-HTTPD-2.2"'
#     if ($Service) {
#        $Service.Delete() 
#     }
#  EOH
#  notifies :run, 'execute[Installing Service Apache]', :immediately
#end

powershell_script 'install Apache service if not exists' do
  code <<-EOH
     $Service = Get-Service -Name Apache-HTTPD-2.2 -ErrorAction SilentlyContinue
     if (! $Service) {
          sc create Apache-HTTPD-2.2 binPath= \"#{apache_work_dir}/bin/httpd.exe\" start= auto DisplayName= \"Apache HTTPD 2.2\"
     }
  EOH
end
