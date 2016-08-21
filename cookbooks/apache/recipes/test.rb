
remote_file 'C:/NC4/MC3/apache-httpd-32-2.2.2.32.zip' do
  source 'http://54.175.158.124:8081/repository/Rigil/apache-httpd-32-2.2.32.zip'
  action :create
  notifies :run, 'execute[Unzip Apache package]', :immediately
end

execute "Unzip Apache package" do
  command 'cd #node{["nc4"]["apache"]["install_location"]}'
  command 'unzip #{node["nc4"]["apache-httpd-32"]["package"]} #node{["nc4"]["apache"]["workdir"]}'
  notifies :run, "execute[Remove Logs]", :immediately
end
