
#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


#check to add the akamai consition in future
use_akamai = "0"

case "#{use_akamai}"
when "0"
	akamai_check = "server_name"
when "1"
	akamai_check = "server_name_akamai"
end

include_recipe "apache::apache"
