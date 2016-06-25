#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Jenkins::job::Provider::base;

use strict;
use warnings;

# VERSION

use Moose;
use Data::Dumper;

use Rex::Commands::Fs;

extends qw(Rex::Resource::Provider);

sub test {
  my ($self) = @_;

  my $job_dir = Rex::Helper::File::Spec->catdir( $Jenkins::jenkins_path, "jobs",
    $self->_folder_path );

  is_dir($job_dir)
    && is_file("$job_dir/config.xml");
}

# RHEL 7
# -> RHEL 7
# Build/Tests/root/RHEL 7
# -> Build/jobs/Tests/jobs/root/jobs/RHEL 7
sub _folder_path {
  my ($self) = @_;
  my @s = split( /\//, $self->name );

  my $p = join( "/jobs/", @s );
  $p =~ s/^\///;
  return $p;
}

sub _myname {
  my ($self) = @_;
  my @s = split( /\//, $self->name );
  return pop @s;
}

1;
