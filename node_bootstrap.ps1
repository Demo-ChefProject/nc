#!/bin/bash

#cd ~/home/jenkins/workspace/Chef-apache/
cd C:\Jenkins\workspace\Chef-apache

# Creates a role for tomcat
#sudo knife role from file /home/jenkins/workspace/Chef-apache/roles/apache.rb
echo "Updating Role from file..."
knife role from file C:\Jenkins\workspace\Chef-apache\roles\apache.json


# Upload cookbooks into Chef Server
echo "Uploading cookbook..."
knife upload cookbooks apache

# Bootstrap a node to its chef server
 knife bootstrap windows winrm 52.23.166.135 --winrm-user Administrator --winrm-password 'd*G%tc9"&"HLK' --node-name Rigil_node_Windows -r 'role[apache]' -y

#Passing credentials stored as a secure string
$pass = ConvertTo-SecureString '?%EW!26tAzW' -AsPlainText -Force
$Chefcred = new-object -TypeName System.Management.Automation.PSCredential -argumentlist "Administrator",$pass

#  Create a remote session to the chef node
$Session = New-PSSession -ComputerName 52.23.166.135 -Credential $Chefcred

#Script which runs the ruby script in the remote server
$Script = {powershell.exe chef-client}

echo "*****"
echo "**Running cookbook..."
echo "*****"
$Job = Invoke-Command -Session $Session -Scriptblock $Script
echo $Job


# Exit and remove the current session
Remove-PSSession -Session $Session


# ssh into the chef node and execute the chef client to run its run list from chef server
#ssh -i /home/ubuntu/.ssh/agiletrailblazers.pem ubuntu@54.175.232.159 "sudo chef-client"
