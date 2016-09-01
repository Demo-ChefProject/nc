
apache_download_from = "#{node['nc4']['nexus']['url']}/#{node['nc4']['apache-httpd-32']['version']}/#{node['nc4']['apache-httpd-32']['package']}"
apache_package_name = node['nc4']['apache-httpd-32']['package']
apache_install_loc = node['nc4']['apache']['install_location']
apache_server_name = node['nc4']['server_name']
apache_backup_touch = node['ohai_time']
akamai_check = node['nc4']['akamai_check']
apache_work_dir = "#{apache_install_loc}/HTTPD"
apache_httpd_conf = "#{apache_work_dir}/conf"

#Check if install location exists
powershell_script 'Create Install Location' do
  guard_interpreter :powershell_script
  code <<-EOH
    New-Item -ItemType Directory -Path #{apache_install_loc}
  EOH
  not_if do Dir.exist?("#{apache_install_loc}") end
end

#Download the Apache zip file
remote_file "#{apache_install_loc}/#{apache_package_name}" do
  source apache_download_from
  action :create
  notifies :run, 'powershell_script[Unzip Apache package]', :immediately
end

#Backup the current install
powershell_script 'backup current install' do
  guard_interpreter :powershell_script
  code <<-EOH
    Rename-Item -path #{apache_work_dir} -newName "#{apache_work_dir}-#{apache_backup_touch}"
  EOH
  not_if do Dir.exist?("#{apache_work_dir}-#{apache_backup_touch}") end
  notifies :run, 'powershell_script[Unzip Apache package]', :immediately
end

#Unzip the installer
powershell_script 'Unzip Apache package' do
  guard_interpreter :powershell_script
  code <<-EOH
    powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('#{apache_install_loc}/#{apache_package_name}', '#{apache_install_loc}'); }"
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
  source "#{akamai_check}.conf"
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
