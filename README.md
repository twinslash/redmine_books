# Redmine Books

Redmine plugin for accounting books

* Maintainer: Dmitry Kovalenok, [Hirurg103](https://github.com/Hirurg103)
* Contact: Report questions, bugs or feature requests on the [IssueTracker](https://github.com/twinslash/redmine_books/issues) or get in touch with me at [dzm.kov@gmail.com](mailto:dzm.kov@gmail.com)

## Istallation

Clone plugin's source code into /plugins application directory
```console
git clone https://github.com/twinslash/redmine_books.git
```
Install all required gems. For example

```console
bundle install --no-deployment --without development test --path vendor/bundle #instead '--no-deployment --without development test --path vendor/bundle' put your specific options
```

Perform the migrations
```console
bundle exec rake redmine:plugins:migrate NAME=redmine_books
```
Restart server.

##Permission configuration

1) Login as administrator.

2) Click on the "Administration" link menu on top panel. Click "Books".

3) Choose users, groups and actions that you want to allow to them.

![](http://farm9.staticflickr.com/8079/8415235260_e6f5a67d4b_c.jpg)

Admin has all rights by default.

### Notice!
User has permissions of groups to which he belongs.

## Features

* The book can be returned by another user(if he has the right)

![](http://farm9.staticflickr.com/8190/8415235350_a712c41311_c.jpg)

* User can look at the history books(who took, when took, when returned, who returned)

![](http://farm9.staticflickr.com/8089/8415235588_1c5087b529_c.jpg)

![](http://farm9.staticflickr.com/8352/8414138965_db111ed633_c.jpg)

* Search by tags
* Apportunity to vote and comment

## Uninstall

Roll back all plugins migrations
```console
bundle exec rake redmine:plugins:migrate NAME=redmine_books VERSION=0
```
Remove /redmine_books directory from /plugins directory
```console
cd redmine_application_path/plugins
rm -rf redmine_books
```

Remove all plugin gems from Gemfile.lock
```console
bundle install --no-deployment --without development test --path vendor/bundle #instead '--no-deployment --without development test --path vendor/bundle' put your specific options
```

Restart server.

## Changelog

* 0.0.3 - Added ability to vote and comment(08.04.2013)
* 0.0.2 - Search by tags(07.03.2013)
* 0.0.1 - Base functionality

