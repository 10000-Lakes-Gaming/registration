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

## Email Settings
To make emails work, you will need to set two environment variables (currently assumes
you'll be using gmail). 

```
export  GMAIL_SMTP_USERNAME=[YOUR EMAIL ADDRESS]
export GMAIL_SMTP_PASSWORD=[YOUR EMAIL PASSWORD]
```
 
