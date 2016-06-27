# Rex Jenkins module

This module setup jenkins.

## STATUS

* This module is tested with Jenkins 2.
* This module is for the current development branch (Rex 2)
* This module is in development state

## Tasks

### setup

Call this task to install jenkins on your system.

*Currently it doesn't installed it, only sets some global variables*

#### Parameters

* ensure - Default: latest
* user, The username or uid of the jenkins user - Default: jenkins
* group, The groupname or gid of the jenkins user's group - Default: jenkins
* jenkins_path, The jenkins home directory.

#### Example

```perl
use Jenkins;

task "setup", sub {
  Jenkins::setup {
    user         => "tomcat",
    group        => "tomcat",
    jenkins_path => "/srv/jenkins",
  };
};
```

## Resources

### folder

Create a job folder. The folders are **not** created recursive.

#### Parameters

* ensure - Default: present
* config_template, If you want to use a special folder configuration template - Default: `template("templates/jenkins/folder.config.xml")`


#### Example

```perl
Jenkins::folder "Builds",
  ensure => "present";

Jenkins::folder "Builds/foo",
  ensure => "present";
```

### job

Create a job.

#### Parameters

* ensure - Default: present
* string_parameters, If you need string parameters for your job - Default `[]`
* choice_parameters, If you need choice parameters for your job - Default `[]`
* git_repository, URL to your git repository.
* git_build_branch, Which branch to build.
* build_command, Shell command to build the job.
* config_template, If you want to use a special folder configuration template - Default: `template("templates/jenkins/job.config.xml")`


#### Example

```perl
Jenkins::job "Build Tests/root/Ubuntu 14.04",
  ensure            => "present",
  string_parameters => [
  {
    name        => "REX_REPO",
    description => "",
    value       => "https://github.com/RexOps/Rex.git",
  },
  {
    name        => "REX_BRANCH",
    description => "",
    value       => "master",
  },
  {
    name        => "BUILD_BRANCH",
    description => "",
    value       => "*/master",
  },
  ],
  choice_parameters => [
  {
    name        => "rex_feature",
    description => "",
    list => [qw/0.42 0.51 0.53 0.54 0.55 0.57 1.0 1.1 1.2 1.3 1.4 1.5/],
  },
  ],
  git_repository   => "https://github.com/RexOps/rex-build.git",
  git_build_branch => '$BUILD_BRANCH',
  build_command    => './run.pl ami-49cb503a';
```

### pipeline

Create a pipeline.

#### Parameters

* ensure - Default: present
* string_parameters, If you need string parameters for your job - Default `[]`
* choice_parameters, If you need choice parameters for your job - Default `[]`
* script, Pipeline groovy script.
* config_template, If you want to use a special folder configuration template - Default: `template("templates/jenkins/pipeline.config.xml")`


#### Example

```perl
Jenkins::pipeline "Build Tests/root",
  ensure            => "present",
  string_parameters => [
  {
    name        => "REX_REPO",
    description => "",
    value       => "https://github.com/RexOps/Rex.git",
  },
  {
    name        => "REX_BRANCH",
    description => "",
    value       => "master",
  },
  {
    name        => "BUILD_BRANCH",
    description => "",
    value       => "*/master",
  },
  ],
  choice_parameters => [
  {
    name        => "rex_feature",
    description => "",
    list => [qw/0.42 0.51 0.53 0.54 0.55 0.57 1.0 1.1 1.2 1.3 1.4 1.5/],
  },
  ],
  script   => template("templates/pipeline.config.tpl", {
    some_special_var => "foo",
    some_other_var => "bar",
  }),
```

