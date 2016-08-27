# apache Cookbook

This cookbook installs and configures apache for Mission Ceter project.

## Requirements

### Platforms

- Windows

### Chef

- Chef 12.0 or later

### Cookbooks

- `apache` - apache cookbook to install for Mission Center.

## Attributes

check attribites folder for all the defined variables.

## Usage

Just include `apache` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[apache]"
  ]
}
```

## Whats does this cookbook do?

```
Copy Apache to target node from Nexus repo
- Check if install location exists
A powershell script is used for this purpose. What this piece of code typically does is, it checks if the install location exists else exit the location.

- Then the Apache zip file is downloaded into that location.
remote_file (chef code) is used for this purpose

What it does?
- A remote_file resource block manages files by using files that exist remotely.

SYNTAX of remote_file

remote_file '/var/www/customers/public_html/index.php' do
  source 'http://somesite.com/index.php'
  owner 'web_admin'
  group 'web_admin'
  mode '0755'
  action :create
end
Link to learn more on this topic of remote_file - https://docs.chef.io/resource_remote_file.html

- Unzip Apache zip in target location
Again a powershell script is used for this purpose.

- Remove the Logs/* files
For the removal of the Log files we make use of Remove-Item in powershell

What it does?
The Remove-Item cmdlet does exactly what the name implies: it enables you to get rid of things once and for all.

SYNTAX of Remove_Item
Remove-Item File_Path\* -recurse

Link to learn more on Remove_Item - https://technet.microsoft.com/en-us/library/ee176938.aspx

- Leave error folder untouched

Update httpd conf
- update workdir location
- Update the log file name for both error and Access log

Create a new server specific file
- The should be created in conf/extra/<hostname>.conf

Modify conf/httpd-vhost.conf for the correct server name inside extra folder.
- update the newly created filename in the httpd-vhosts.conf file

- Check and create Apache service if not existing
```
