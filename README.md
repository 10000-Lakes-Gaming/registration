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

 All of the settings below should be added to this file, or loaded in another way, else the 
 application will not work properly (you will get errors!).

### Email settings
The app currently assumes you'll be using gmail as your SMTP service, and that you have
the appropriate account with the appropriate permissions. These should be added to `config/app_environment_variables.rb`.
```
  ENV['GMAIL_SMTP_USERNAME']= '[YOUR GMAIL ACCOUNT]'
  ENV['GMAIL_SMTP_PASSWORD']= '[YOUR GMAIL PASSWORD]'
```

### Stripe Payment Service settings. 
The application uses [Stripe](https://stripe.com/) as its payment service. To use, you will need to set 
up a user with Stripe (which is free), and get the test API keys. These keys will need to be added, as such:
```
  ENV['PUBLISHABLE_KEY']    = '[YOUR PUBLIC KEY]'
  ENV['SECRET_KEY']         = '[YOUR SECRET KEY]'
```

### More configs to come?