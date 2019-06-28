# TIL Notes
I built this project while going through Rails Tutorial to learn Ruby on Rails. It was inspired by my friends who taught me about creating a "Today I learned" (TIL) repo to write down all my notes of new things I've learned. Users can create an account to create a cheatsheet contribution to the learning community. They can also "favorite" other user's cheatsheets and follow users. 
You can view the application here: [https://tilnotes.herokuapp.com/](https://tilnotes.herokuapp.com/)

## Development Notes

### Accomplished by 06/27/2019
* Create User authentication with cookie-based Sessions resource
* Create tables for users, cheatsheets, relationships, favorites
* Add admin privileges to delete users
* Enable users to search through cheatsheets by tag
* Enable users to follow/unfollow other Users
* Enable users to create cheatsheets
* Enables users to edit their profiles
* Enable users to "favorite" other user's cheatsheets
* Practice test-driven-development and write tests for models/controllers
* Add option to make cheatsheet private
* Add option to edit and delete cheatsheet
* Update the front-end of the application
* Add link on user profile to enable easy access to their "favorite" cheatsheets

### Future Tasks
* None for now :) 

### Bugs
* None yet... but I'm on the lookout!

## Install

### Clone the repository

```shell
git clone git@github.com:janessatran/railsapp.git
cd railsapp
```

### Check your Ruby version

```shell
ruby -v
```

The output should start with something like `ruby 2.6.3`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 2.6.3
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler)
```shell
bundle
```


### Initialize the database

```shell
rails db:create db:migrate db:seed
```
