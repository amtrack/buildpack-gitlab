# Heroku buildpack: gitlab

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpacks) for [gitlab](http://google.com/?q=gitlab).

[![Build Status](https://secure.travis-ci.org/amtrack/buildpack-gitlab.png?branch=master)](http://travis-ci.org/amtrack/buildpack-gitlab)

## Usage

Example usage:

    $ ls
    hello.txt

    $ heroku create --stack cedar --buildpack https://github.com/amtrack/buildpack-gitlab

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom buildpack
    -----> gitlab app detected

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
