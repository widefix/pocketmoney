# BUDGETINGkid

## Request protection

Rack::Attack rejects probes for secret files (`.env` variants, `.git`, `.ssh`,
private keys) with HTTP 403 before routing and exception reporting. Rules match
paths rather than user-agent names, which scanners can spoof.

Dynamic requests are limited to 300 per client IP per minute. Exceeding the limit
returns HTTP 429 with `Retry-After`. GET/HEAD `/health` checks are excluded, and
static files are served before this middleware. Client IPs use Rails' trusted
proxy handling; keep the application behind the deployment proxy, which must
preserve the actual client address in its forwarding headers.

Counters use a separate, bounded in-memory cache for the current single-process
Puma deployment. They reset on restart and are not shared across processes or
containers. Before scaling, configure `Rack::Attack.cache.store` with a shared
Redis or Memcached store. Path blocking does not depend on the counters.

Run the database-independent middleware checks with:

```sh
bundle exec rspec spec/middleware/rack_attack_spec.rb
```

It's a debt management app that creates a formalised record of debts between you and your friends.

## Requirements

- postgresql
- Ruby 3.4.6
- Rails 7.2

## Installation

- clone [repository](https://bitbucket.org/ka8725/pocketmoney)
- create config for **database.yml**
- `bundle install`
- `bundle exec rake db:create`
- `bundle exec rake db:migrate`
- `bundle exec rake db:seed`

## Database configuration

Execute this command to configure database:

```bash
$ cp config/database.yml.example config/database.yml
```


## Run app

To run app, you need to start a web server on your development machine. You can do this by running the following command in the blog directory:

```
bin/rails server
```

To see application, open a browser window and navigate to http://localhost:3000.
