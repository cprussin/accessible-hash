# Accessible Hash

http://rubygems.org/gems/accessible-hash

## Description

Accessible Hash is a simple wrapper around the built-in Ruby Hash that behaves
like a HashWithIndifferentAccess and also allows `object.attribute` style
access.

## Install

Manually:

```bash
gem install accessible-hash
```

or with Bundler (add to your `Gemfile`):

```ruby
gem 'accessible-hash'
```

## Usage

```ruby
require 'accessible-hash'

foo = AccessibleHash.new(bar: 'baz')
foo['bar']  # => 'baz'
foo[:bar]   # => 'baz'
foo.bar     # => 'baz'
```
