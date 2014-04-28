# [Accessible Hash](http://cprussin.net/accessible-hash)

[![Gem Version](https://badge.fury.io/rb/accessible-hash.svg)](http://rubygems.org/gems/accessible-hash) [![Dependency Status](https://gemnasium.com/cprussin/accessible-hash.svg)](https://gemnasium.com/cprussin/accessible-hash)

## Description

Accessible Hash is a simple wrapper around the built-in Ruby Hash that behaves
like a `HashWithIndifferentAccess` and also allows `object.attribute` style
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
