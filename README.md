# POCKETMONEY

Track pocket money of your kids. Allow them buying what they want. Save nerves. Save your budget and time.

## Requirements

- postgresql
- ruby 2.7.4
- rails 6.1.4

## Installation

- clone [repository](https://bitbucket.org/ka8725/pocketmoney)
- create config for **database.yml**
- `bundle install`
- `bundle exec rake db:create`
- `bundle exec rake db:migrate`
- `bundle exec rake db:seed`

## Database configuration

Create configuration file `database.yml` in `/config` folder and insert this code.

```
default: &default
  adapter: postgresql
  encoding: unicode
  port: 5432
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: pocketmoney_development

test:
  <<: *default
  database: pocketmoney_test

production:
  <<: *default
  database: pocketmoney_production
```

## Run app

To run app, you need to start a web server on your development machine. You can do this by running the following command in the blog directory:

```
bin/rails server
```

To see application, open a browser window and navigate to http://localhost:3000.