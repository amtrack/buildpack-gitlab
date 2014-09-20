# Buildpack: GitLab (work in progress)

This is a [Buildpack](http://devcenter.heroku.com/articles/buildpacks) for [GitLab](http://gitlab.org/) to be used in combination with the [heroku-buildpack-ruby](https://github.com/heroku/heroku-buildpack-ruby) through [heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi).

[![Build Status](https://drone.mrolke.de/github.com/amtrack/buildpack-gitlab/status.svg?branch=master)](https://drone.mrolke.de/github.com/amtrack/buildpack-gitlab) master

## How does it work?

> While the [buildpack-gitlab](https://github.com/amtrack/buildpack-gitlab) will setup [gitlab-shell](https://github.com/gitlabhq/gitlab-shell) and do some magic,

> the [heroku-buildpack-ruby](https://github.com/heroku/heroku-buildpack-ruby) will take care of [gitlabhq](https://github.com/gitlabhq/gitlabhq) itself.

## Getting started
### Requirements

1. A PaaS like
	* [dokku](https://github.com/progrium/dokku)
	* [dokku-alt](https://github.com/dokku-alt/dokku-alt)
	* ~~heroku~~ (it has only an *ephemeral filesystem*)
2. At least **1GB of RAM** and **swap enabled**
3. A `redis` and (`postgres` or `mariadb`) addon
4. Additional persistent storage
5. Additional port forwarding for the SSH port

### General instructions

Tell your PaaS to use the multi buildpack:

```
BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
```

with the buildpacks *buildpack-gitlab* and *heroku-buildpack-ruby*:
```console
$ git checkout -b deployment
$ echo -e "https://github.com/amtrack/buildpack-gitlab.git\nhttps://github.com/heroku/heroku-buildpack-ruby.git" > .buildpacks
$ git add .buildpacks
$ git commit -m "prepare for deployment"
```

### PaaS specific instructions
Depending on your **PaaS**, see the detailed instructions
for

* creating the application
* managing required addons
* managing persistent storage and
* managing port forwarding

PaaS | Instructions
---- | ------------
**dokku** | <https://github.com/amtrack/buildpack-gitlab/wiki/dokku>
**dokku-alt** | <https://github.com/amtrack/buildpack-gitlab/wiki/dokku-alt>

## Environment variables

### SMTP_URL
Setting the SMTP credentials in the syntax `smtps://<user>:<password>@<smtp_url>/?domain=<domain>`

Example:

	SMTP_URL=smtps://john.doe:asdf1234@smtp.gmail.com/?domain=gmail.com

### GITLAB_SHELL_VERSION
Specifying the gitlab-shell version.

Currently the default `gitlab-shell` version will be read from the **file** `GITLAB_SHELL_VERSION`.
If you want to use another version you can set the **environment variable** `GITLAB_SHELL_VERSION` (mind prefixing the version number with a *v* in the environment variable).

Example:

	GITLAB_SHELL_VERSION=v2.0.0

## Info

Most of the GitLab Installation stuff is borrowed from

 * [sameersbn/docker-gitlab](https://github.com/sameersbn/docker-gitlab)

This buildpack was generated with the Yeoman generator [generator-buildpack](https://github.com/amtrack/generator-buildpack)

## Known Issues

See [here](https://github.com/amtrack/buildpack-gitlab/wiki/KnownIssues)
