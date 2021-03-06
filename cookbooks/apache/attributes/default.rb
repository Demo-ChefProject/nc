#Variable definitions for apache cookbook
default['nc4']['nexus']['url']="http://54.175.158.124:8081"
default['nc4']['apache-httpd-32']['version']="repository/Rigil"
#default['nc4']['nexus']['url']="http://devmcnexus21.nc4.local:8081/repository/maven-releases"
#default['nc4']['apache-httpd-32']['version']="org/apache/apache-httpd-32/2.2.32"
default['nc4']['apache-httpd-32']['package']="apache-httpd-32-2.2.32.zip"

#Apache install location variables
default['nc4']['apache']['install_location'] = "C:/NC4/MC3"
default['nc4']['server_name'] = "MC3AgileDev"

#check to add the akamai condition in future
default['nc4']['use_akamai'] = File.exist?("jenkins_params.txt") ? File.read("jenkins_params.txt") : "YES"

case node['nc4']['use_akamai']
when "NO"
	default['nc4']['akamai_check'] = "server_name"
when "YES"
	default['nc4']['akamai_check'] = "server_name_akamai"
end

