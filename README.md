## Chat

[![Code Climate](https://codeclimate.com/github/growthrepublic/chat.png)](https://codeclimate.com/github/growthrepublic/chat)

This is an app for group conversations using websockets. It provides versioned API for managing conversations as well as versioned messaging through websockets.

Thanks to [Nick Gauthier](https://github.com/ngauthier/tubesock), it leverages Rails 4's new full-stack concurrency support. Therefore we have used a concurrent server of choice - Puma.

We have not added authentication because of two reasons:

1. As this is a sample app we want to keep things simple,

2. We use this app as one of the internal apps, so authentication is done somewhere else.


### Installation

Clone this repository to your machine with:

```
  git clone git@github.com:growthrepublic/chat.git
```

It will create a directory with the same name as repository and put everything there. Go to that directory and install dependencies:

```
  bundle install
```

At the moment of writing we use Ruby 2.1.1. Probably any Ruby 2.x.x will work just fine.


### System Dependencies

#### Mongo DB

You can install it easily by downloading [binaries](https://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.6.1.tgz). Read more on the [official website](http://www.mongodb.org/).

#### Redis

Redis on OSX can be installed using [Homebrew](http://brew.sh/):

```
  brew install redis
```

Read more on the [official website](http://redis.io/).


### Configuration

Make sure to edit `config/secrets.yml` and copy `config/mongoid.yml.sample` as `config/mongoid.yml`. Then you should be good to go :)

If you are using custom configuration for Redis make sure to reflect it in `config/initializers/websocket_messaging.rb`.


### Usage

Before sending a message user has to subscribe to a conversation first. It can be done either by creating a new one or by being invited to an already existing one.

#### Starting a conversation

You can start a conversation by making a POST request to `/api/v1/conversations?people_ids[]=<id>&people_ids[]=<id>`. In return  you will get a newly created conversation, which contains its unique `id`.

#### Invite to a conversation

If conversation has been already created, you can invite others to join it by making a POST request to `/api/v1/conversations/<conversation_id>/invite?people_ids[]=<id>&people_ids[]=<id>`. In return you will get an updated conversation.

#### List conversations

To obtain a paginated list of conversations user is subscribed to make a GET request to `/api/v1/conversations?user_id=<id>&page=<page>&per_page=<per_page>`. It returns recently active first.

#### List conversation messages

To obtain a paginated list of messages make a GET request to `/api/v1/conversations/<conversation_id>/messages?page=<page>&per_page=<per_page>`. It returns list of messages with most recent first.

#### Sending messages

Sending messages is done by websockets. It has to be a serialized JSON object. Required fields are: `type`, `body` and `conversation_id`. Type should be set to `message`. Let's assume that in the future there will be other types like information about seeing a message by someone else.

#### Channels

Each user has its own channel, which all of the messages are sent through. It does not matter what conversation they belong to as long as user subscribes them. WebSockets can be found at `/chat/v1/users/<user_id>`.

### Tests

To run the entire suite make sure that you have `chromedriver` installed. On OSX we recommend to use [Homebrew](http://brew.sh/) to manage system dependencies. You can install chromedriver:

```
  brew install chromedriver
```

Then run tests with:

```
  bin/rspec spec
```

### Contributing

1. Fork it ( https://github.com/growthrepublic/chat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
