# railsapp 
A rails web application that helps people organize themselves when learning something new. Not quite sure what to call it yet, which is why the repo is called 'railsapp' for now. 

Features to implement:
- User login 
- User profile
- creation of Goal
- User Notes?

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```