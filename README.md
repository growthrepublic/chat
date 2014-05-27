## Chat

This is an app for group conversations using websockets. It provides versioned API for managing conversations as well as versioned messaging through websockets.

Thanks to [Nick Gauthier](https://github.com/ngauthier/tubesock), it leverages Rails 4's new full-stack concurrency support. Therefore we have used a concurrent server of choice - Puma.

We have not added authentication because of two reasons:

1. As this is a sample app we want to keep things simple,

2. We use this app as one of the internal apps, so authentication is done somewhere else.


### Installation

Clone this repository to your machine with:

  git clone git@github.com:growthrepublic/chat.git

It will create a directory with the same name as repository and put everything there. Go to that directory and install dependencies:

  bundle install

At the moment of writing we use Ruby 2.1.1. Probably any Ruby 2.x.x will work just fine.


### System Dependencies

#### Mongo DB

You can install it easily by downloading [binaries](https://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.6.1.tgz). Read more on the [official website](http://www.mongodb.org/).

#### Redis

Redis on OSX can be installed using [Homebrew](http://brew.sh/):

  brew install redis

Read more on the [official website](http://redis.io/).


### Configuration

Make sure to edit `config/secrets.yml` and copy `config/mongoid.yml.sample` as `config/mongoid.yml`. Then you should be good to go :)

If you are using custom configuration for Redis make sure to reflect it in `config/initializers/websocket_messaging.rb`.


### Tests

To run the entire suite make sure that you have `chromedriver` installed. On OSX we recommend to use [Homebrew](http://brew.sh/) to manage system dependencies. You can install chromedriver:

  brew install chromedriver

Then run tests with:

  bin/rspec spec


### Contributing

1. Fork it ( https://github.com/growthrepublic/chat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
