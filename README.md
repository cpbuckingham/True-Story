# Clicker App

An app that makes it easy to give feedback during a class.

## Local Setup

1. `bundle`
1. `cp .env{.example,}`
1. Add your correct username and password in the connection string in `.env`
1. `createdb -U gschool_user clicker`
1. `createdb -U gschool_user clicker_test`
1. `sequel -m db/migrate postgres://gschool_user:password@localhost:5432/clicker`
1. `rackup`
