# Heroku buildpack: GitLab

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks) for [GitLab](http://gitlab.org/).

[![Build Status](https://secure.travis-ci.org/amtrack/buildpack-gitlab.png?branch=master)](http://travis-ci.org/amtrack/buildpack-gitlab)
[![Build Status](https://drone.io/github.com/amtrack/buildpack-gitlab/status.png)](https://drone.io/github.com/amtrack/buildpack-gitlab/latest)

## Usage

### Prepare gitlab repository

Checkout gitlabhq:

	$ git clone https://github.com/gitlabhq/gitlabhq.git
	$ cd gitlabhq
	$ git checkout -b deployment

Create and commit `.buildpacks`:

        $ echo "https://github.com/amtrack/buildpack-gitlab.git" > .buildpacks
        $ echo "https://github.com/heroku/heroku-buildpack-ruby.git" >> .buildpacks
	$ git add .buildpacks
	$ git commit -m "prepare for dokku"

Add ruby version and `rails_12factor` gem to Gemfile and rebuild Gemfile.lock:

        $ awk '/^source/{print $0"\nruby \"2.0.0\"\ngem \"rails_12factor\""};!/^source/' Gemfile > Gemfile.tmp
        $ mv Gemfile{.tmp,}
        $ bundle install
        $ git commit -am"Add ruby and rails12factor to Gemfile"

Create a dokku application on the server:

	$ git remote add dokku <your-dokku-url>:<your-app-name>
	$ git push dokku deployment:master

The push will fail with the following message

    **********
    No supporting environment detected!
    Please create supporting application services.
    **********

Assuming you have the following section configured in your ssh client config file (located at `~/.ssh/config`)

```ssh
Host dokku
   HostName dokku.example.com
   User dokku
   RequestTTY yes
```



Configure the app on your dokku server:

	$ dokku config:set gitlab BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
	$ dokku config:set gitlab CURL_TIMEOUT=120
	$ dokku config:set gitlab SMTP_URL=smtps://user:password@smtp.gmail.com/?domain=gmail.com
	$ dokku mariadb:create gitlab
	$ dokku redis:create gitlab
	$ cat < /home/dokku/gitlab/DOCKER_ARGS EOF
	-v /opt/gitlab/repositories:/home/git/repositories
	-v /opt/gitlab/.ssh:/home/git/.ssh
	-p 2222:22
	EOF

Push again:

	$ git push dokku deployment:master

Seed the database:

	$ dokku run gitlab bundle exec rake db:setup RAILS_ENV=production
	$ dokku run gitlab bundle exec rake db:seed_fu RAILS_ENV=production

## Required dokku plugins

 * [dokku-user-env-compile](https://github.com/musicglue/dokku-user-env-compile)
 * [dokku-supervisord](https://github.com/statianzo/dokku-supervisord)
 * [dokku-postgres-plugin](https://github.com/jezdez/dokku-postgres-plugin) or [dokku-md-plugin](https://github.com/Kloadut/dokku-md-plugin)
 * [dokku-redis-plugin](https://github.com/luxifer/dokku-redis-plugin)
 * [dokku-docker-args](https://github.com/amtrack/dokku-docker-args) or [dokku-persistent-storage](https://github.com/dyson/dokku-persistent-storage)

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
