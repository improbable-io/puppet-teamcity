## Overview 
![Transformation](https://raw.githubusercontent.com/grundic/puppet-teamcity/master/puppet-teamcity.gif?raw=true)
This Puppet module installs and configures TeamCity build agent (https://www.jetbrains.com/teamcity).

A TeamCity Build Agent is a piece of software which listens for the commands from the TeamCity
server and starts the actual build processes. It is installed and configured separately from the
TeamCity server. An agent can be installed on the same computer as the server or on a different
machine (the latter is a preferred setup for server performance reasons).

## Usage
Here is an example how to use this module:
```puppet
include '::teamcity::agent'
```
Here is sample of usage with some parameters:
```puppet
class {'::teamcity::agent':
  agent_name            => 'sample-build-agent',
  manage_user           => true,
  manage_group          => true,
  custom_properties     => {
      'system.teamcity.idea.home' => '%system.agent.home.dir%/tools/idea'
  },
  launcher_wrapper_conf => {
    'wrapper.app.parameter.11' => '-Dfile.encoding=UTF-8'
  }
}
```

Also you can parametrize class from hiera:
```yaml
teamcity::agent::agent_name: sample-build-agent
teamcity::agent::agent_dir: /var/tainted/build-agent
teamcity::agent::custom_properties:
  "system.teamcity.idea.home": "%system.agent.home.dir%/tools/idea"
```

##Reference

##Classes

* teamcity::params: Default configuration parameters
* teamcity::agent: Main class for installation and configuration.
* teamcity::agent::config: Internal class for managing configuration
* teamcity::agent::install: Handles package installation.
* teamcity::agent::service: Handles service status.

###Parameters

####`agent_name`
Build agent name, that will be displayed on Teamcity server. By defaults set to hostname.

####`agent_user`
User name, which will be used to run and configure build agent. Defaults to `teamcity`.

####`agent_user_home`
If user is managed, set it's home dir. Defaults to $agent_dir.

####`manage_agent_user_home`
Manage whether to create home dir for user. Defaults to `false`.

####`agent_group`
Name of group to be used for build agent. Defaults to `teamcity`.

####`manage_user`
Whether to create user for build agent. Defaults to `false`.

####`manage_group`
Whether to create group for build agent. Defaults to `false`.

####`server_url`
Root url of Teamcity server. It will be used in agent's config. Defaults to `http://builder`.

####`archive_name`
Name of archive that should be downloaded from `server_url`. Defaults to `buildAgent.zip`.

####`download_url`
Calculated parameter, that is used to download build agent distributive.
Defaults to `${server_url}/update/${archive_name}`.

####`agent_dir`
Installation path, where build agent will reside.
Defaults to `/opt/build-agent`.

####`work_dir`
Work path used by teamcity.
Defaults to `..\work`.

####`temp_dir`
Temp path used by teamcity.
Defaults to `..\temp`.

####`system_dir`
System path used by teamcity.
Defaults to `..\system`.

####`service_ensure`
Required service status. Defaults to `running`.

####`service_enable`
Should the service be enabled. Defaults to `true`.

####`service_run_type`
The mode in which agent is executed: it could be `service` or `standalone`
for Windows and `init` or `systemd` on Linux. On Windows system: if set
to `service`, then agent is executed as regular windows service. In 
standalone mode the shortcut is created in Startup forlder of specified
user. This mode is required in some cases to overcome service's
shortcomings (it could interact with desktop, so, it could not for
example create direct3d device).
Default on Windows is `service` and on Linux `init` or `systemd` depending
on your OS version.

####`teamcity_agent_mem_opts`
String for configuring additional java parameters for build agent.

####`custom_properties`
Hash of custom properties, that will be applied to conf/buildAgent.properties

####`launcher_wrapper_conf`
Hash of custom properties, that will be applied to launcher/conf/wrapper.conf
