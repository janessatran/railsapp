# railsapp 
A rails web application that allows people to create notes in markdown related to whatever programming topic, displays those notes in a nice way, and lets them easily find their markdown notes with a search feature. Not quite sure what to call it yet, which is why the repo is called 'railsapp' for now. 

## How things are structured so far (last updated: 05/08/19):
### Models:
- User: name, email, password, password_confirmation
- Cheatsheet: title, topic, content (references User)

### Controllers:
- Users: new, show, create
- Cheatsheets: new, show, create

### Views:
- Users: new (signup page), show (name, email, created at date... need to update this to show a profile!!!)
- Cheatsheets: new (unimplemented), show (displays content field)

## Features to implement:
- User login 
- User profile
- Cheatsheets
- Search bar to find cheatsheets
- Editing cheatsheets (through github?)



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