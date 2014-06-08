# Heroku buildpack: GitLab (work in progress)

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks) for [GitLab](http://gitlab.org/).

[![Build Status](http://mrolke.de:8080/github.com/amtrack/buildpack-gitlab/status.svg?branch=master)](http://mrolke.de:8080/github.com/amtrack/buildpack-gitlab)

## Getting started

### Requirements

* [dokku](https://github.com/progrium/dokku) (heroku has only an *ephemeral filesystem*)
* All of [these dokku plugins](#requirements)
* At least **1GB of RAM** and **swap enabled**

### Checkout gitlabhq

	$ git clone https://github.com/gitlabhq/gitlabhq.git
	$ cd gitlabhq

### Prepare your application for deploying to `dokku`

	$ git checkout -b deployment
    $ echo -e "https://github.com/amtrack/buildpack-gitlab.git\nhttps://github.com/heroku/heroku-buildpack-ruby.git" > .buildpacks
	$ git add .buildpacks
	$ git commit -m "prepare for dokku"

### Create a dokku application on the server

	$ git remote add dokku <your-dokku-url>
	$ git push dokku deployment:master # will fail

### Configure the app on your dokku server

	root@vps:$ dokku config:set gitlab BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
	root@vps:$ dokku config:set gitlab CURL_TIMEOUT=120
	root@vps:$ dokku mariadb:create gitlab
	root@vps:$ dokku redis:create gitlab

### Push the application

	$ git push dokku deployment:master

### Seed the database

	root@vps:$ dokku run gitlab bundle exec rake db:setup RAILS_ENV=production
	root@vps:$ dokku run gitlab bundle exec rake db:seed_fu RAILS_ENV=production

### Test the deployment

	root@vps:$ dokku run gitlab bundle exec rake gitlab:check RAILS_ENV=production

Open `https://gitlab.<yourdomain>` in your browser.

## Advanced usage

### Persistent storage

Create some folders for persistent storage:

	root@vps:$ test -d /opt/gitlab/repositories || sudo mkdir -p /opt/gitlab/repositories; sudo chown -R dokku:root /opt/gitlab/repositories
	root@vps:$ test -d /opt/gitlab/.ssh || sudo mkdir -p /opt/gitlab/.ssh; sudo chown -R dokku:root /opt/gitlab/.ssh

Set some docker options for persistent storage:

	root@vps:$ dokku docker-options:add gitlab "-v /opt/gitlab/repositories:/home/git/repositories"
	root@vps:$ dokku docker-options:add gitlab "-v /opt/gitlab/.ssh:/home/git/.ssh"

Rebuild the app to apply the docker options:

	root@vps:$ dokku rebuild gitlab

### Exposing the SSH port to access the git repositories (work in progress)

You will need to make some changes in the `config/gitlab.yml` file (see instruction at [GitLab Installation Guide](https://github.com/gitlabhq/gitlabhq/blob/master/doc/install/installation.md#user-content-custom-ssh-connection))
and expose the containers port `22` to the host port `2222` (for example).

First tell dokku to expose the port when the app is build again

	root@vps:$ dokku docker-options:add gitlab "-p 2222:22"

Then create the config based on the example config file

	$ cp config/gitlab.yml.example config/gitlab.yml
	$ git add -f config/gitlab.yml
	$ git commit -am "force add config/gitlab.yml"

Make the following changes

	* gitlab.host: gitlab.<yourdomain>
	* gitlab_shell.ssh_port: 2222

Commit and push the changes

	$ git commit -am "expose repositories on port 2222 via SSH"
	$ git push dokku deployment:master

### Setting the SMTP credentials

	root@vps:$ dokku config:set gitlab SMTP_URL=smtps://<user>:<password>@smtp.gmail.com/?domain=gmail.com

### Specifying the gitlab-shell version

Currently the default `gitlab-shell` version is set to `v1.9.5`. If you want to use another version you can do this via the environment variable `GITLAB_SHELL_VERSION`.

	root@vps:$ dokku config:set gitlab GITLAB_SHELL_VERSION=v1.9.X

## <a name="requirements"></a>Required dokku plugins

 * [dokku-user-env-compile](https://github.com/musicglue/dokku-user-env-compile)
 * [dokku-supervisord](https://github.com/statianzo/dokku-supervisord)
 * [dokku-md-plugin](https://github.com/Kloadut/dokku-md-plugin)
 * [dokku-redis-plugin](https://github.com/luxifer/dokku-redis-plugin)
 * [dokku-docker-options](https://github.com/dyson/dokku-docker-options)
 * [dokku-rebuild](https://github.com/scottatron/dokku-rebuild)

## Info

Most of the GitLab Installation stuff is borrowed from

 * [sameersbn/docker-gitlab](https://github.com/sameersbn/docker-gitlab)

This buildpack was generated with the Yeoman generator [generator-buildpack](https://github.com/amtrack/generator-buildpack)

Hacking
-------

To make changes to this buildpack, fork it on Github. Push up changes to your fork, then create a new Heroku app to test it, or configure an existing app to use your buildpack:

```
# Create a new Heroku app that uses your buildpack
heroku create --buildpack <your-github-url>

# Configure an existing Heroku app to use your buildpack
heroku config:set BUILDPACK_URL=<your-github-url>

# You can also use a git branch!
heroku config:set BUILDPACK_URL=<your-github-url>#your-branch
```

## Known Issues

See [here](https://github.com/amtrack/buildpack-gitlab/wiki/KnownIssues)

## Testing

[Anvil](https://github.com/ddollar/anvil) is a generic build server for Heroku.

```
gem install anvil-cli
```

The [heroku-anvil CLI plugin](https://github.com/ddollar/heroku-anvil) is a wrapper for anvil.

```
heroku plugins:install https://github.com/ddollar/heroku-anvil
```

The [ddollar/test](https://github.com/ddollar/buildpack-test) buildpack runs `bin/test` on your app/buildpack.

```
heroku build -b ddollar/test # -b can also point to a local directory
```

For more info on testing, see [Best Practices for Testing Buildpacks](https://discussion.heroku.com/t/best-practices-for-testing-buildpacks/294) on the Heroku discussion forum.
