# Redmine Books

Plugin for accounting books

* Maintainer: Dmitry Kovalkenok, [Hirurg103](https://github.com/Hirurg103)
* Contact: Report questions, bugs or feature requests on the [IssueTracker](https://github.com/twinslash/redmine_books/issues) or get in touch with me at [dzm.kov@gmail.com](mailto:dzm.kov@gmail.com)

## Istallation

Clone plugin's source code into /plugins application directory
```console
git clone git@github.com:twinslash/redmine_books.git
```
Perform the migrations
```console
bundle exec rake redmine:plugins:migrate NAME=redmine_books
```
Restart server.

##Permission configuration

* Login as administrator.
* Click on the "Administration" link menu on top panel. Click "Books".
* Choose users, groups and actions that you want to allow to them.
![](http://farm9.staticflickr.com/8359/8412970727_698318b824_z.jpg)

Admin has all rights by default.

### Notice!
User has permissions of groups to which he belongs.

## Features

* The book can be returned by another user(if he has the right)
![](http://farm9.staticflickr.com/8471/8413012085_34b5b7b279_m.jpg)
* User can look at the history books(who took, when took, when returned, who returned)
![](http://farm9.staticflickr.com/8328/8413031159_b3c4e5c445_m.jpg)
![](http://farm9.staticflickr.com/8237/8413036661_e1171a5c00_m.jpg)

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
