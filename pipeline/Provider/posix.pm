#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Jenkins::pipeline::Provider::posix;

use strict;
use warnings;

# VERSION

use Rex -minimal;

use Moose;

use Rex::Commands::File;

use Rex::Resource::Common;
use Data::Dumper;

extends qw(Jenkins::pipeline::Provider::base);
with qw(Rex::Resource::Role::Ensureable);

sub present {
  my ($self) = @_;

  my $pipeline_dir = Rex::Helper::File::Spec->catdir( $Jenkins::jenkins_path, "jobs",
    $self->_folder_path );

  file $pipeline_dir,
    ensure => "directory",
    owner  => $Jenkins::user,
    group  => $Jenkins::group,
    mode   => '0750';

  file "$pipeline_dir/config.xml",
    content => $self->config->{config_template},
    owner   => $Jenkins::user,
    group   => $Jenkins::group,
    mode    => '0640';

  $self->_set_status(created);

  return 1;
}

sub absent {
  my ($self) = @_;

  my $pipeline_dir = Rex::Helper::File::Spec->catdir( $Jenkins::jenkins_path, "jobs",
    $self->_folder_path );

  file $pipeline_dir, ensure => "absent";

  $self->_set_status(removed);

  return 1;
}

1;
