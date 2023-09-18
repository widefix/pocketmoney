# BUDGETINGkid

It's a debt management app that creates a formalised record of debts between you and your friends.

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