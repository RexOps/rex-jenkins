#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:
#
# (c) Jan Gehring
#

package Jenkins;

use strict;
use warnings;

use Rex -minimal;
use Rex::Commands::File;
use Rex::Commands::Service;

use Rex::Resource::Common;

use Jenkins::folder::Provider::posix;
use Jenkins::job::Provider::posix;
use Jenkins::pipeline::Provider::posix;
eval {
  # For Rex > 1
  use Rex::Commands::Template;
  use Rex::Commands::Task;
};

our ( $user, $group, $jenkins_path ) =
  ( "jenkins", "jenkins", "/var/lib/jenkins" );

task "setup", sub {
  $user         = param_lookup "user",         "jenkins";
  $group        = param_lookup "group",        "jenkins";
  $jenkins_path = param_lookup "jenkins_path", "/var/lib/jenkins";

  file "$jenkins_path/jobs",
    ensure => "directory",
    owner  => $user,
    group  => $group,
    mode   => '0750';
};

resource "folder", sub {
  my $folder_name = resource_name();

  my $folder_config = {
    ensure          => param_lookup( "ensure", "present" ),
    config_template => param_lookup(
      "config_template", template("templates/jenkins/folder.config.xml")
    ),
    name => $folder_name,
  };

  my $provider = param_lookup( "provider", "Jenkins::folder::Provider::posix" );

  Rex::Logger::debug("Get Jenkins::folder provider: $provider");

  return ( $provider, $folder_config );
};

resource "job", sub {
  my $job_name = resource_name();

  my $job_config = {
    ensure => param_lookup( "ensure", "present" ),
    string_parameters => param_lookup( "string_parameters", [] ),
    choice_parameters => param_lookup( "choice_parameters", [] ),
    git_repository   => param_lookup( "git_repository",   "" ),
    git_build_branch => param_lookup( "git_build_branch", "" ),
    build_command    => param_lookup( "build_command",    "" ),
    config_template  => param_lookup(
      "config_template", template("templates/jenkins/job.config.xml")
    ),
    name => $job_name,
  };

  my $provider = param_lookup( "provider", "Jenkins::job::Provider::posix" );

  Rex::Logger::debug("Get Jenkins::job provider: $provider");

  return ( $provider, $job_config );
};

resource "pipeline", sub {
  my $pipeline_name = resource_name();

  my $pipeline_config = {
    ensure => param_lookup( "ensure", "present" ),
    string_parameters => param_lookup( "string_parameters", [] ),
    choice_parameters => param_lookup( "choice_parameters", [] ),
    script          => param_lookup( "script", "" ),
    config_template => param_lookup(
      "config_template", template("templates/jenkins/pipeline.config.xml")
    ),
    name => $pipeline_name,
  };

  my $provider =
    param_lookup( "provider", "Jenkins::pipeline::Provider::posix" );

  Rex::Logger::debug("Get Jenkins::pipeline provider: $provider");

  return ( $provider, $pipeline_config );
};

1;
