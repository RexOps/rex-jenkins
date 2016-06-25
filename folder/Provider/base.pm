#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Jenkins::folder::Provider::base;

use strict;
use warnings;

# VERSION

use Moose;
use Data::Dumper;

use Rex::Commands::Fs;
use Rex::Helper::File::Spec;

extends qw(Rex::Resource::Provider);

sub test {
  my ($self) = @_;

  my $job_dir = Rex::Helper::File::Spec->catdir($Jenkins::jenkins_path, "jobs", $self->_folder_path, $self->_myname);

  is_dir($job_dir)
    && is_dir("$job_dir/jobs")
    && is_file("$job_dir/config.xml");
}

# Build/Tests/root
# -> Build/jobs/Tests/jobs/root/jobs
sub _folder_path {
  my ($self) = @_;
  my @s = split(/\//, $self->name);
  my $myname = pop @s;
  return "" unless @s;

  my $p = join("/jobs/", @s) . "/jobs";
  $p =~ s/^\///;
  return $p;
}

sub _myname {
  my ($self) = @_;
  my @s = split(/\//, $self->name);
  return pop @s;
}

1;
