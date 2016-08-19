#!/bin/bash

#cd ~/home/jenkins/workspace/Chef-apache/
cd C:\Jenkins\workspace\Chef-apache\nc

# Creates a role for tomcat
#sudo knife role from file /home/jenkins/workspace/Chef-apache/roles/apache.rb
knife role from file C:\Jenkins\workspace\Chef-apache\nc\roles\apache.rb


# Upload cookbooks into Chef Server
knife upload cookbooks apache

# Bootstrap a node to its chef server
# knife bootstrap windows winrm 54.175.57.21 --winrm-user Administrator --winrm-password 'd*G%tc9"&"HLK' --node-name Rigil_node_Windows -r 'role[apache]' -y

#Passing credentials stored as a secure string
$Pass = cat C:\securestring.txt | convertto-securestring
$Pegacred = new-object -TypeName System.Management.Automation.PSCredential -argumentlist "Administrator",$pass
#  Create a remote session to the chef node
$Session = New-PSSession -ComputerName 54.175.57.21 -Credential $Pegacred

$Script = {powershell.exe chef-client}

$Job = Invoke-Command -Session $Session -Scriptblock $Script
echo $Job
#Script which runs the ruby script in the remote server


# Exit and remove the current session
Remove-PSSession -Session $Session


# ssh into the chef node and execute the chef client to run its run list from chef server
#ssh -i /home/ubuntu/.ssh/agiletrailblazers.pem ubuntu@54.175.232.159 "sudo chef-client"
