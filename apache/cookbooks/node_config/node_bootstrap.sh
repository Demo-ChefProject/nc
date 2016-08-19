#!/bin/bash

#cd ~/home/jenkins/workspace/Chef-apache/

# Creates a role for tomcat
sudo knife role from file /home/jenkins/workspace/Chef-apache/roles/apache.rb
#knife role from file C:\Jenkins\workspace\Chef-apache\roles\apache.rb


# Upload cookbooks into Chef Server
knife upload cookbooks apache

# Bootstrap a node to its chef server
sudo knife bootstrap 54.175.232.159 --ssh-user ubuntu --sudo --identity-file /home/ubuntu/.ssh/agiletrailblazers.pem -N Rigil_Node -r 'role[apache]'
#knife bootstrap windows winrm 54.175.57.21 --winrm-user Administrator --winrm-password 'd*G%tc9&HLK' --node-name Rigil_node_Windows -r 'role[apache]'
# Run this command to add the Host to the Jenkins slave(One time process)
#ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/agiletrailblazers.pem ubuntu@54.175.232.159 "sudo chef-client"

# ssh into the chef node and execute the chef client to run its run list from chef server
#ssh -i /home/ubuntu/.ssh/agiletrailblazers.pem ubuntu@54.175.232.159 "sudo chef-client"
