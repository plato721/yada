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

*Important note* Be sure to select the `herokuapp.com` url in the Servers dropdown to test the endpoints in the
Swagger docs.

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

## Notes to Hotel Engine

### Some questionable items

- Security

So we're generating a complicated token (if a user doesn't provide, anyway),
which is fine. But we're sending and expecting the token in unadulterated
clear text, and storing it in the same way. Not great.

But the idea was to show I was thinking about security, and to pave the way for
something more robust down the line. The `AuthenticatedController` could
potentially be altered based on a revised system.

Anyway, the bottom line is, it's not secure right now.

- `rest-client`

It's a dependency for vcr. Except, it's not. There are other options. It's fairly
heavy depedndency-wise, and if I've already got another client for the quote
fetching, why not use the same one?

I'd want to research a fairly simple one that would work for all cases. HTTP
clients are classic for proliferating and causing dependency conflict in large
apps. And this is how it starts.

- Test coverage

Yes, there are a number of tests, but I'd say it's far from complete. Search results received fairly light treatment, for
instance. Some say things like that are "testing the framework." Well, I would say that it's ensuring using the
framework is getting the results you want.

### Various notables

- rswag

I'd never used it before, or the Swagger spec. We have it at iCentris, but knowledge about it wasn't widely
disseminated, so it's only used by a couple of people. For my API work, I've been testing with Postman and writing
markdown docs with how to use. It's adequate, and gives that sense of seeing with your own eyes that it's working.

rswag gives a way to generate interactive docs but tie them into specs. I'm glad I explored it here. I'm probably not
using totally correctly or to its full potential, but I think it added something to the experience and hopefully to the
project as a whole.

But looking at things like the massive hash for the search spec, for instance, I don't love it. This spec could probably be
tightened up in some way to make it more readable.

- Refactoring into a search pipeline

The commit b399492 (along with one piece from the commit before it) show a refactoring from kind of a batch process
into something a bit more object oriented. The "scope" or "result set" seemed to be passed from one step to the next,
along with the initial search parameters to do so. The user performing the search was needed at the end to
record that the search took place.

Often times when things are traveling along together, they are asking to live in an object together. After the simple
results object was created, the objects working on it just needed to implement the same interface to really simplify
things. So instead of `sorter.sort` and `filterer.filter`, just requiring that they all implement `execute` and `errors`
allowed a clean-looking looping through of steps. Currently the added caching is absent from this, but the cache write
is an easy snap-in and probably appropriate to add.

It also may be asked why all the things in this process pipeline are object instances... This design may present a
memory use problem as garbage collection in ruby is notoriously problematic due to the dynamic nature of the language.
But dropping object creation from the setup wouldn't be too difficult a prospect.

## Closing

It was fun to `rails new` and building something. I took longer than the 4 hours requested, and it still leaves plenty
to be desired. But thank you for inviting me to participate in the process, and I look forward to your comments.
