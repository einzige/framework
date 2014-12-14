Ruby Framework
=========

[![Gem Version](https://badge.fury.io/rb/framework.svg)](http://badge.fury.io/rb/framework)

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
- Setting up an interview? Use Framework!
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

### Run console to play

```shell
rake console
```

![screen shot 2014-11-28 at 17 14 48](https://cloud.githubusercontent.com/assets/370635/5226522/dcfbdc42-7719-11e4-9af9-602d1e68e0fa.png)

### Generate database migration

```shell
framework g migration create_users
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
| |____migrate
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

### Configuration

Configurations are stored in `config/application.yml`. Note, that as opposed to Rails, even initializers and models are listed as custom paths in `autoload_paths` section. This gives you a flexibility to explicitly say which paths and what exactly used in your app. Don't need no initializers? Don't list them in autoload paths. Order matters.

```yaml
development: &common
  enable_logging: yes
  autoload_paths:
    - app/models
    - app/managers
  default_timezone: 'Pacific Time (US & Canada)'

test:
  <<: *common
  enable_logging: no

staging:
  <<: *common

production:
  <<: *common
  enable_logging: no
```

### More docu and updates coming soon

I encourage you to contribute! :)
