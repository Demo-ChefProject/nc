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
- Take backup of the current HTTPD folder
- Unzip Apache zip in target location
- Remove the Logs/* files
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