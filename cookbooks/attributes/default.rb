#default['tomcat']['default']['port']  = "8081"
#Variable definitions for apache cookbook
default['nc4']['nexus']['url']="http://devmcnexus21.nc4.local:8081"
default['nc4']['apache-httpd-32']['version']="/repository/maven-releases/org/apache/apache-httpd-32/2.2.32"
default['nc4']['apache-httpd-32']['package']="/apache-httpd-32-2.2.32.zip"

#Apache install location variables
default['nc4']['apache']['install_location'] = "D:\NC4\MC3"
default['nc4']['apache']['workdir'] = "D:\NC4\MC3\HTTPD"
default['nc4']['apache']['logdir'] = "D:\NC4\MC3\logs"
