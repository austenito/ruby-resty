[![Build Status](https://travis-ci.org/austenito/ruby-resty.png)](https://travis-ci.org/austenito/ruby-resty)

# Ruby-Resty

Ruby-Resty is a ruby port of [Resty][1], which provides a simple way to interact with RESTful services. Ruby-Resty was
ported to be shell agnostic and for easier community development.

The resty REPL is built on top of [Pry][2] for built-in niceties like history, state management, shell interaction, 
etc.

# Installation

```
gem install ruby-resty
```

# Supported Ruby Versions

* Ruby 1.9.3
* Ruby 2.0.0

# Usage

## The REPL

To get started, you can enter the REPL by providing the `host` option.

```
ruby-resty --host http://nyan.cat
resty>
```

If you would like headers to be attached with every request, you can do so:

```
ruby-resty --host http://nyan.cat --headers X-NYAN-CAT-SECRET-KEY=nyan_nyan X-NYAN-TYPE=octo
```

### REPL Options

The REPL accepts the following options that are attached to each request. This provides an easier way to make multiple
requests without having to specify headers everytime.

```
--alias, -a <s>:   The per-host entry to use in ~/.ruby_resty.yml
--host, -h:    The hostname of the REST service. Ex: http://nyan.cat
--headers, -H: The headers attached to each request. Ex: X-NYAN-CAT-SECRET-KEY=nyan_nyan
--verbose, -v: Verbose mode
--config, -c : Use host information from ~/.ruby_resty.yml
```

### Making Requests

Requests can be sent to services by specifying a path and any associated JSON data. The following methods are 
supported:

```
GET     [path]
PUT     [path] [data]
POST    [path] [data]
HEAD    [path]
DELETE  [path]
OPTIONS [path]
TRACE   [path]
```

For example you might want to send a `GET` request, which doesn't require a body:

```
resty> GET /api/cats/1
{ 
  "nyan_cat": { 
    "name": "octo"
    "color": "green"
  }
}
```

Or you can send a `POST` request, which does require a body:

```
resty> POST /api/cats '{"nyan_cat": {"name": "oliver", "color": "blue"} }'
{ 
  "nyan_cat": { 
    "name": "oliver"
    "color": "blue"
  }
}
```

### REPL Commands

There are also REPL specific commands ruby-resty is aware of. For example, you can type `exit` to quit the REPL.

```
exit: Quits the REPL
```

## Per Host Configuration

Including options from the command-line can get tedious, especially if you specify different options to different
hosts. The `~/.ruby_resty.yml` config file allows per-host configuration.

To get started, you can call a generator:

```
rake copy_config
```

This will copy `~/.ruby_resty.yml` which allows you to specify options related to specific hosts.

```
nyan:
  host: http://nyan.cat
  headers:
    header_name: header_value
    header_name2: header_value2
```

Now instead of starting the REPL like:

```
ruby-resty --host http://nyan.cat --headers header_name=header_value header_name2=header_value2
```

You can omit the header information:

```
ruby-resty --alias nyan
```

# Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

Don't forget to run the tests with `rake`

[1]: https://github.com/micha/resty
[2]: https://github.com/pry/pry
