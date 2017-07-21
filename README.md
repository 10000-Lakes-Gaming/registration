# Registration application

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

