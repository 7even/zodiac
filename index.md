## Overview

`zodiac` is a ruby library for finding one's zodiac sign by a date of birth.

## Installation

``` bash
$ gem install zodiac
```

or

``` ruby
# Gemfile
gem 'zodiac'
```

## Usage

### Time/Date/DateTime usage

``` ruby
require 'zodiac'
Time.now.zodiac_sign                  # => "Aries"
require 'date'
Date.new(2011, 1, 1).zodiac_sign      # => "Capricorn"
DateTime.new(2011, 4, 30).zodiac_sign # => "Taurus"
```

Zodiac sign names are retrieved from `I18n` and can be added to standard locales if your language isn't yet supported by the gem.

``` ruby
Date.new(1989, 2, 26).pisces? # => true
Time.gm(1978, 7, 12).gemini?  # => false
```

### ActiveRecord usage

Suppose you have a date of birth in `dob` column.

``` ruby
# app/models/person.rb
class Person < ActiveRecord::Base
  zodiac_reader :dob
end
```

Now your `Person` instances have the same zodiac functionality as `Time` and `Date`:

``` ruby
@person = Person.first
@person.zodiac_sign    # => "Taurus"
@person.libra?         # => false
@person.taurus?        # => true
```

### ActiveRecord searching by zodiac sign

``` bash
$ rails generate zodiac:migration Person
$ rake db:migrate
```

``` ruby
Person.with_zodiac_sign('libra') # returns all libras
Person.gemini                    # all the geminis
```

## Included locales

* en (English)
* ru (Russian)
* pt-BR (Brazilian Portuguese)
* ja (Japanese)
* it (Italian)
* es (Spanish)
* de (German)
* zh-CN (Chinese)
* fr (French)
* lv (Latvian)
* zh-TW (Traditional Chinese)
* uk (Ukrainian)
