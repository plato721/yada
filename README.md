# README

This is currently a toy-grade app for searching what are alleged
to be quotes from the Seinfeld television series. This is
dependent on an [external API](https://seinfeld-quotes.herokuapp.com/) and no accuracy is guaranteed. This
is done in good fun for educational purposes, so hopefully falls
within the fair use doctrine of intellectual property law.

## Using the API

The app is currently deployed at `https://yada-yada-yada.herokuapp.com` and
there you will find interactive documentation at [/api-docs](https://yada-yada-yada.herokuapp.com/api-docs), but
below are a few notes to get you started.

- Create a token by `post`ing an email address to `/users/create` in
the body of a json payload.

`post /users/create, { user: { email: <some unique email address> } }`

A token will be sent in the payload of the reply if the email address
was unique. No validation of the email will be performed, nor will an email be sent for confirmation.

Once a token is received, it may be passed as a header param in calls to all other endpoints:

```
{ token: <token> }
```

Within the interactive
docs, you may click on the lock on any endpoint or at the top of the list, provide your token, and the token
param will be passed automatically.

- Get all quotes via:

`get /quotes`

- Search quotes via:

`post /search, { match_text: <some text that may be in the quotes> }`

A `filters:` object is also accepted, along with a `sort:`. Filtering is currently limited to character name (Jerry, Elaine, etc.), and sorting to the body of the quote itself. Example, to find all
quotes that contain "hello" not said by Jerry, sorted in descending order, post
this json:
```
{ "search": {
    "match_text":"hello",
    "filters": {
      "not": {
        "characters": ["Jerry"]
      }
    },
    "sort": {
      "body": "desc"
    }
  }
}
```


- Once again, please check out more detail via the interactive documentation found at:

[https://yada-yada-yada.herokuapp.com/api-docs](https://yada-yada-yada.herokuapp.com/api-docs)

*Important note* Be sure to select the appropriate url for testing the endpoints, which is the  `herokuapp.com` url if you are connecting to the Heroku url above.

## Running the App locally

Install the system dependencies, clone the repo, and bundle:

```
gem install bundler
bundle install
```

* Ruby version
  - Use ruby 2.6.3

* System dependencies

  - PostgreSQLhttps://yada-yada-yada.herokuapp.com/api-docs

* Database setup

  - Install PostgreSQL (locally tested with version 12.4)
  - Quick setup of database and populating the quote and associated tables:
```(ruby)
rails yada:app_setup
```
Or, follow individual steps below:

  - Create local test/dev databases:
```
rails db:create
rails db:migrate
rails yada:fetch_quotes
```
Currently, `fetch_quotes` is idempotent, but will not remove/update quotes if they are changed. That is, if you want a
clean slate, please drop the database or wipe the tables and re-run the job. There is a task to do that if you like:
```(ruby)
rails yada:clean_slate
```

* How to run the test suite

  - Install gem dependencies via:
    ```(ruby)
    gem install bundler
    bundle install
    ```
   - run specs via:
    ```
    rspec spec
    ```
     - The app is dependent upon an external API, but there is a recorded cassette within `/fixtures/vcr_cassettes`
that should allow the specs to pass. Remove it to force an external test.
