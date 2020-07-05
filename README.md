# Registration application

## Table of Contents
- [Setup your local development environment](#setup)
  - [Environment](#environment)
  - [Dependencies](#dependencies)
    - [Ruby](#ruby)
  - [Database](#database)
    - [schema.rb](#schema.rb)
    - [SQLite3](#sqlite)
- [Get Started](#getting-started)
- [Testing](#testing)
- [Code Standards](#code-standards)
- [Committing Code](#commiting-code)

----
## Setup
The following assumes that you are doing your work on a Macintosh. It will try to be IDE/Editor agnostic. It also assumes that you have [Home Brew](https://brew.sh/) on your machine. At this point, for other development environments, I am not going to be able to give a lot of help.

### Make sure Home Brew is up to date
Before you try doing any of these, you should make sure that your homebrew app is up to date, and cleaned up. Please run:
```
% brew update
% brew doctor
```
These may give you some suggestions that will make your system work better. It is probably a good idea to fix whatever `brew doctor` tells you to.

Use your discretion on deleting things... make sure that they are not used.
Keeping your homebrew updated is probably a good thing. Consider adding a crontab such as:

```
0 12 * * * /usr/local/bin/brew update && /usr/local/bin/brew upgrade && /usr/local/bin/brew cleanup >> .brew/brew.log 2>&1 
```
You can add this with `crontab -e`  

---
### Environment
As this is being built as a [12-factor app](https://12factor.net/), most configuration will be done as environment variables. Most are listed far below .


### Dependencies
#### Ruby
This application is written in Ruby. It is expected that you will be using [rbenv](https://github.com/rbenv/rbenv) as
your ruby environment manager, and our scripts are set up to require that.

On a Mac, you can install `rbenv` with:
```
% brew install rbenv
``` 
To make sure your rbenv (and ruby-build) are up to date, please run when you first checkout the project:
This will also be done in the [update](script/update) script.
```
brew upgrade rbenv ruby-build
```

For the current release, we will be using **Ruby 2.7.1**. Please make sure that you have this version installed with:
```
% rbenv install 2.7.1
```
The project's setup script will make sure that your local `.ruby-version` has the correct version in it. 

**NOTE** Please make sure that you do _not_ have `RBENV_VERSION` set in your shell (from `~/.bash_profile`), as this will overwrite any local settings. 


### Database  
Like most applications, PFS registration uses databases
#### Schema.rb  
Rails uses a `db/schema.rb` file to keep track of the changes, and to rebuild the database fast.  However, it is changed every time you run a migration:
`bundle exec rails db:migrate`

Please make sure that there are real changes before checking it in. It is excluded from rubocop, so only real schema changes will be there. 

Note that objects like views, created by SQL query, will not be represented.

#### SQLite3  
For running tests and local development, we use SQLite3.
Migrations are created in such a way that any views, mviews, or table that are from outside of our schema are mocked as real tables in SQLite3 schemas. These are referred to as `mocked_instances`, and currently are our development and test environments.

To run, you will need to have SQLite3 installed. 
`brew install sqlite3` 
(or something like that.) 


---
## Getting Started
Immediately after cloning this repository, you should `cd` into your local repo, and run:
```
% ./script/setup
```
This will attempt to install the needed ruby gems and set up a few other things, such as `overcommit`. It will also tell you if you are missing any dependencies to build or test the application.

From there, you could run the tests
```
% ./script/test
```
or run the server. Note that by default Rails apps will run locally on [http://localhost:3000](http://localhost:3000) 
```
% ./script/server
```

To run Rails Console, you can simply use the `console` script with:
```
% ./script/console
```
Any of these should tell you if you are missing any needed dependencies or executables. 

It is a goal of this project to be able to run the server and all tests locally without a network connection. As such, we will be using `SQLite3
 as our test and development database, while staging and production will utilize Oracle or mySQL.

---
## Testing
Unit and integration testing of the applications modules and classes will be handled with `rspec`. Test specs will be stored in `./spec`, and should be organized by the directory structure of the objects or other files. 

Example: Tests for `app/controller/WelxomeController` should be located in `spec/controller/WelcomeControllerSpec`

Our goal is near 100% code coverage. That being said, we should not be testing Rails itself, ActiveRecord, and the like. This also means that if files are created by Rails generators (such as helpers or concerns), please remove them if they are not being used.  
 
---
## Code Standards
We will be using `rubocop` to enforce code styling. As we are starting fresh, there are very few cops that are being exluded, if any.  

---
## Commiting code
Prior to commiting code, you should run `bundle exec rubocop -a` to make sure your code passes code styling. If you do not, `overcommit` will be checking your code style, and prevent you from commiting code. 

Overcommit will also be checking your commit statements, but mostly for line length and basic formatting. You can read about good commit messages on [Chris Beam's blog on git commits](https://chris.beams.io/posts/git-commit/).

When you are commiting a change that is not complete (due to needing to switch drivers, end of day, or what have you), please start the commit message with `WIP: [What this commit will eventually do]` so that we can tell that it was not complete.

When you are commiting the final change that fixes an issue, always add a line with `Fixes: #[ISSUE NUMBER]`


------   


## Other Development Considerations
------

A few things to note, for early documentation.

To "register" is to create the `UserEvent`... associate the user with the event. 
This does not pay for the event, however, though this is a planned future enhancement.
   
Adding a table creates the `RegistrationTable` (the bridge between the `UserEvent` and
 the actual `Table`).
 
`Events` have `Sessions`, 
`Sessions` have `Tables`
`Tables` have `Scenanios`

`Users` have `UserEvents`
`UserEvents` have `RegistrationTables` 
_note, `RegistrationTable` was a holdout from before adding `Devise` for 
authentication... was easier to leave that, and rename/recreate the `UserEvents`
instead of `Registrations`_

## Settings
 The application is a "12-factor" app, so is looking for some environment variables. 
 When deployed to heroku, they will be part of the heroku setup, but for local development
 servers, you will want to create a `config/app_environment_variables.rb`. **This file must not
  be checked into git!** (as such, it is included in `.gitignore`)

```
if Rails.env.development? || Rails.env.test?
# put env properties here
end
```

 All of the settings below should be added to this file, or loaded in another way, else the 
 application will not work properly (you will get errors!).

### Email settings
The app currently assumes you'll be using gmail as your SMTP service, and that you have
the appropriate account with the appropriate permissions. These should be added to `config/app_environment_variables.rb`.

Typically this will be using mailgun, our email provider.
```
  ENV['DEFAULT_SENDER']     =      '[YOUR EMAIL ADDRESS]'
  ENV['MAILGUN_DOMAIN']     =      '[YOUR MAILGUN DOMAIN]'
  ENV['MAILGUN_PASSWORD']   =      '[YOUR MAILGUN PASSWORD]'
  ENV['MAILGUN_SMTP_LOGIN'] =      '[YOUR MAILGUN LOGIN]'
  ENV['MAILGUN_SMTP_PORT']  =      '587'
  ENV['MAILGUN_SMTP_SERVER']=      'smtp.mailgun.org'

```

### Stripe Payment Service settings. 
The application uses [Stripe](https://stripe.com/) as its payment service. To use, you will need to set 
up a user with Stripe (which is free), and get the test API keys. These keys will need to be added, as such:
```
  ENV['PUBLISHABLE_KEY']    = '[YOUR PUBLIC KEY]'
  ENV['SECRET_KEY']         = '[YOUR SECRET KEY]'
```

For testing Stripe credit card payments, see [Test Card numbers](https://stripe.com/docs/testing#cards)

### More configs to come?

## Setting up your development environment
Since this application is a Rails 5.0 application, setting up a development environment is relatively easy. You will 
probably want to have a ruby environment manager (such as [rbenv](https://github.com/sstephenson/rbenv)) installed, as
well as ruby 2.3.3 installed. 

Then, if you haven't done so already, you will need to run the following:
* `gem install bundler`
* `bundle install`
* Possibly update [db/seeds.rb](db/seeds.rb) with your own user and password, though you can always 
create a user in the application, and use `rails console` to update to be an admin if you want.
* `bundle exec rails db:create`
* `bundle exec rails db:migrate`
* `bundle exec rails db:seed`
* set up the `config/app_environment_variables.rb` as stated above
* Run the server as `bundle exec rails server`
* Point your browser to `http://localhost:3000`

A shell script, [rebuild-database.sh](rebuild-database.sh) has been provided to drop, create, and populate your
local schema. Additionally, it will start up rails server by calling `bundle exec rails server`

## Copying data from production to DEV or Staging using parity
[Parity](https://robots.thoughtbot.com/how-to-back-up-a-heroku-production-database-to-staging)

## Repository Best Practices
Have an idea for the application? Create an issue! https://github.com/10000-Lakes-Gaming/registration/issues

Solving an existing issue? Don't forget to link your commit and update the issue appropriately! https://help.github.com/en/articles/closing-issues-using-keywords
