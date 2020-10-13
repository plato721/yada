# README

This is currently a toy-grade app for searching what are alleged
to be quotes from the Seinfeld television series. This is
dependent on an external API and no accuracy is guaranteed. This
is done in good fun for educational purposes, so hopefully falls
within the fair use doctrine of intellectual property.

## Using the API

There is interactive documentation at `<base_url>/api-docs`, but
below are a few notes to get you started.

- Create a token by `post`ing an email address to `/users/create` in
the body of a json payload.

`post /users/create, { email: <some unique email address> }`

A token will be sent in the payload of the reply if the email address
was unique. No emails will be sent with a token or otherwise. This is
toy grade, people.

Pass the token as a header param in calls to all other endpoints.

- Get all quotes via:

`get /quotes`

- Search quotes via:

`post /search, { match_text: <some text that may be in the quotes> }`

- Check out more detail via the interactive documentation found at:

`<base_url>/api-docs`

## Running the App locally

Install the system dependencies first, clone the repo, and bundle:

```
gem install bundler
bundle install
```

* Ruby version
  - Use ruby 2.6.3

* System dependencies

  - PostgreSQL

* Database setup

  - Install PostgreSQL (locally tested with version 12.4)
  - Create local test/dev databases:

    `rails db:create`

    `rails db:migrate`

* How to run the test suite

  - Install gem dependencies via:

    `gem install bundler`

    `bundle install`
- run specs via:

`rspec spec`

The app is dependent upon an external API, but there is a recorded cassette
that should allow the specs to pass. Remove it to force an external test.

* Services (job queues, cache servers, search engines, etc.)

## Notes on the HE Assignment

- Security

So we're generating a complicated token (if a user doesn't provide, anyway),
which is fine. But we're sending and expecting the token in unadulterated
clear text, and storing it in the same way. Not great.

But the idea was to show I was thinking about security, and to pave the way for
something more robust down the line. The `AuthenticatedController` could
potentially be altered based on a revised system.

Anyway, the bottom line is, it's not secure right now.


