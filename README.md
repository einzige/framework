Ruby Framework
=========

Framework to build Ruby applications for all your needs. Inspired by Rails, but clear and clean from any web-related backend.

### Features

- Easy configuration to work with multiple databases
- ActiveRecord interface
- Customizable structure
- YAML configuration
- Appication generators
- Useful console mode
- ... Find more

### When to use

- Obviously, you need a framework :)
- You need to quickly start a project from scratch 
- You want to have your backend code to stay separate from any large frameworks (like Rails)
- You want to build some "worker" application running your business logic with no interface
- Wanna build web application? You can easily integrate your code into any web framework (Rack, Rails etc) (see below)
- You don't want to learn a new framework, you are the one who knows only Rails :)
- You want to test something quickly and you don't want to waste your time setting new environment up

### Quick start

1) Install Framework at the command prompt if you haven't yet:

```shell
gem install framework
```

2) Create a new application:

```shell
framework new myapp
```

### Structure

Pretty similar to Rails (just a sample):

```
.
|____app
| |____models
| | |____concerns
| | | |____.keep
| | |____task.rb
| | |____user.rb
| |____tasks
| | |____hello.rake
|____config
| |____application.yml
| |____databases.yml
| |____environment.rb
| |____initializers
| | |____time_zone.rb
|____db
| |____migrations
| | |____.keep
| | |____20141128085924_create_tasks.rb
| | |____20141128090211_create_users.rb
|____Gemfile
|____Gemfile.lock
|____lib
| |____.keep
|____Rakefile
|____README.md
```

### More docu and updates coming soon

I encourage you to contribute! :)
