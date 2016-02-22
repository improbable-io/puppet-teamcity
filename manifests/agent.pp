# == Class: teamcity::agent
#
# This class would install and configure Teamcity build agent.
#
# === Parameters
# [*agent_name*]
#   Build agent name, that will be displayed on Teamcity server.
#   Defaults to hostname.
#
# [*agent_user*]
#   User name, which will be used to run and configure build agent.
#   Defaults to `teamcity`.
#
# [*agent_user_home*]
#   If user is managed, set it's home dir.
#   Defaults to $agent_dir.
#
# [*manage_agent_user_home*]
#   Manage whether to create home dir for user.
#   Defaults to `false`.
#
# [*agent_group*]
#   Name of group to be used for build agent.
#   Defaults to `teamcity`.
#
# [*manage_user*]
#   Whether to create user for build agent.
#   Defaults to `false`.
#
# [*manage_group*]
#   Whether to create group for build agent.
#   Defaults to `false`.
#
# [*server_url*]
#   Root url of Teamcity server. It will be used in agent's config.
#   Defaults to `http://builder`.
#
# [*archive_name*]
#   Name of archive that should be downloaded from `server_url`.
#   Defaults to `buildAgent.zip`.
#
# [*download_url*]
#   Calculated parameter, that is used to download build agent distributive.
#   Defaults to `${server_url}/update/${archive_name}`.
#
# [*agent_dir*]
#   Installation path, where build agent will reside.
#   Defaults to `/opt/build-agent`.
#
# [*service_ensure*]
#   Required service status.
#   Defaults to `running`.
#
# [*service_enable*]
#   Should the service be enabled
#   Defaults to `true`.
#
# [*service_run_type*]
#   Service type
#   On windows defaults to `service`, on Linux defaults to `init`.
#
# [*work_dir*]
#   Path to the work directory.
#   Defaults to `..\work`.
#
# [*temp_dir*]
#   Path to the temp directory.
#   Defaults to `..\temp`.
#
# [*system_dir*]
#   Path to the system directory.
#   Defaults to `..\system`.
#
# [*teamcity_agent_mem_opts*]
#   String for configuring additional java parameters for build agent
#
# [*custom_properties*]
#   Hash of custom properties, that will be applied to conf/buildAgent.properties
#
# [*launcher_wrapper_conf*]
#   Hash of custom properties, that will be applied to launcher/conf/wrapper.conf
#
#
# === Examples
#
# === Authors
# grundic jordigg
#
# === Copyright
# Copyright 2012-2014 Grigory Chernyshev
class teamcity::agent (
  $agent_name              = $teamcity::params::agent_name,

  $agent_user              = $teamcity::params::agent_user,
  $agent_user_home         = $teamcity::params::agent_user_home,
  $manage_agent_user_home  = $teamcity::params::manage_agent_user_home,
  $agent_group             = $teamcity::params::agent_group,
  $manage_user             = $teamcity::params::manage_user,
  $manage_group            = $teamcity::params::manage_group,

  $server_url              = $teamcity::params::server_url,
  $archive_name            = $teamcity::params::archive_name,
  $download_url            = $teamcity::params::download_url,
  $agent_dir               = $teamcity::params::agent_dir,

  $service_ensure          = $teamcity::params::service_ensure,
  $service_enable          = $teamcity::params::service_enable,
  $service_run_type        = $teamcity::params::service_run_type,

  $work_dir                = $teamcity::agent::work_dir,
  $tempDir                 = $teamcity::agent::temp_dir,
  $systemDir               = $teamcity::agent::system_dir,

  $teamcity_agent_mem_opts = $teamcity::params::teamcity_agent_mem_opts,
  $custom_properties       = $teamcity::params::custom_properties,
  $launcher_wrapper_conf   = $teamcity::params::launcher_wrapper_conf,
) inherits ::teamcity::params {

  validate_string($agent_name)

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin' ] }

  Class['teamcity::agent'] ->
  class {'::teamcity::agent::install':} ->
  class {'::teamcity::agent::config':} ~>
  class {'::teamcity::agent::service':}
}
