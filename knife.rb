# Ubuntu Configuration
#log_level                :info
#log_location             STDOUT
#node_name                'sasi'
#client_key               '/home/ubuntu/.ssh/sasi.pem'
#validation_client_name   'sasi'
#validation_key           '/home/ubuntu/.ssh/atb-chef-admin.pem'
#chef_server_url          'https://54.211.154.197/organizations/atb'
#syntax_check_cache_path  '/home/jenkins/workspace/Chef-CookbookUpload/.chef/syntax_check_cache'
#cookbook_path            '/home/jenkins/workspace/Chef-apache/cookbooks/'
#knife[:node_log_max_files] = 9
#knife[:node_log_path] = '/var/log/chef-server/nodes'
#cookbook_path            ["#{current_dir}/../cookbooks/"]

#######################
# Windows configuration
log_level                :info
log_location             STDOUT
node_name                'sasi'
client_key               'C:\chef\client.pem'
validation_client_name   'sasi'
validation_key           'C:\chef\atb-chef-admin.pem'
chef_server_url          "https://54.211.154.197/organizations/atb"
cookbook_path            "C:/Jenkins/workspace/Chef-apache/cookbooks"

#######################
# Windows configuration
#current_dir = File.dirname(__FILE__)
#log_level                :info
#log_location             STDOUT
#node_name                "atb-admin"
#client_key               "C:\chef\atb-admin.pem"
#chef_server_url          "https://54.82.249.62/organizations/atb"
#cookbook_path            "C:/Jenkins/workspace/Chef-apache/cookbooks"