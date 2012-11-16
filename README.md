# Rakurai

Rakurai is Basic Authentication Pass Server

## Installation

Git clone

    $ git clone https://github.com/naoto/rakurai.git

And then execute:

    $ bundle install 

Or [Bundlizer](http://github.com/Tomohiro/bundlizer) install

    $ bundlizer install naoto/rakurai

## Configuration

Write config.yaml

 * base_uri: Send Server URL to Root
 * username: Basic Authentication User
 * password: Basic Authentication Pass

## Usage

```shell
$ bundle exec bin/rakurai
```

execute Option

 * `-p`, `--port`   :Ruckup Port

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
