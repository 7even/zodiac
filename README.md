# zodiac [![Build Status](https://secure.travis-ci.org/7even/zodiac.png)](http://travis-ci.org/7even/zodiac)

`zodiac` is a simple gem for getting a zodiac sign from a given date of birth. It extends `Time`, `Date` and `DateTime` objects with a `#zodiac_sign` method and can also extend `ActiveRecord::Base` with several instance (delegated to some date attribute of the model object) and class methods (allowing you to search for objects with a certain zodiac sign)

## Installation

``` bash
gem install zodiac
```

Or, if you want to extend your rails app, add the following to the `Gemfile`:

``` ruby
gem 'zodiac'
```

and run `bundle install`.

## Usage

### Time/Date/DateTime usage

``` ruby
require 'zodiac'
Time.now.zodiac_sign                  # => "Aries"
require 'date'
Date.new(2011, 1, 1).zodiac_sign      # => "Capricorn"
DateTime.new(2011, 4, 30).zodiac_sign # => "Taurus"
```

`#zodiac_sign` returns values using `I18n` with "zodiac.#{sign}" path, so if you want your own translations, you can put them in your locale with keys like `zodiac.aries`, `zodiac.taurus` etc. See examples [here](http://github.com/7even/zodiac/blob/master/lib/locales/en.yml).

There are also predicate methods which return `true` if the date is matching the specified zodiac sign (and `false` otherwise).

``` ruby
Date.new(1989, 2, 26).pisces? # => true
Time.gm(1978, 7, 12).gemini?  # => false
```

### ActiveRecord usage

The first thing you need to do is to add `gem 'zodiac'` to your `Gemfile` as described before.

To add zodiac methods to your model you just call a `zodiac_reader` macro in your model passing it the name of the attribute containing the date of birth:

``` ruby
class Person < ActiveRecord::Base
  zodiac_reader :dob
end
```

and then you'll be able to get zodiac sign of your object just by calling `#zodiac_sign` on it:

``` ruby
@person = Person.first
@person.zodiac_sign    # => "Taurus"
```

You can also use the predicate methods like `#libra?`

``` ruby
@person.libra?         # => false
@person.taurus?        # => true
```

If you also need to search for all geminis in your `people` table, you should add an integer field containing a numerical id of the person's zodiac sign to that table. `zodiac` can help you with that - it already includes a generator `zodiac:migration` which creates a migration adding that field to your table (and an index on that field). You should specify the name of your model class as the first argument while calling the generator:

``` bash
rails generate zodiac:migration Person
```

(Note that you must call `zodiac_reader` in your model in order for the migration to run correctly - after creating a new field the migration tries to update it for all existing records)

Now `zodiac_reader` macro in your model gives you some scopes to filter objects by a zodiac sign:

``` ruby
Person.with_zodiac_sign('libra') # returns all libras
Person.gemini                    # all the geminis
```

To keep the consistency of a zodiac sign with the date of birth, `zodiac_reader` also installs a `before_save` filter to your model, which updates the sign field every time you change the date-of-birth attribute.

If you don't like the name of the field containing zodiac sign (by default it's `zodiac_sign_id`), you can customize it, passing the wanted name as an option to `zodiac_reader` in your model and then as the second parameter to the generator:

``` ruby
class Person < ActiveRecord::Base
  zodiac_reader :dob, :sign_id_attribute => :custom_sign_id
end
```

``` bash
rails generate zodiac:migration Person custom_sign_id
```

## Included locales

* en (English)
* ru (Russian)
* pt-BR (Brazilian Portuguese) - thanks [jeffrydegrande](https://github.com/jeffrydegrande)
* ja (Japanese) - thanks [hamakn](https://github.com/hamakn)
* it (Italian) - thanks [lucapette](https://github.com/lucapette)
* es (Spanish) - thanks [jazminschroeder](https://github.com/jazminschroeder)
* de (German) - thanks [contradictioned](https://github.com/contradictioned)

## Changelog

* 0.1 Initial version with Time/Date/DateTime extension and [:ru, :en] locales
* 0.1.1 Added Brazilian Portuguese locale (thanks [jeffrydegrande](https://github.com/jeffrydegrande))
* 0.2 Added ActiveRecord support (scopes, predicate methods and delegating `#zodiac_sign` to date-of-birth attribute)
* 0.2.1 Added Japanese locale (thanks [hamakn](https://github.com/hamakn))
* 0.2.2 Added Italian locale (thanks [lucapette](https://github.com/lucapette))
* 0.2.3 Added Spanish locale (thanks [jazminschroeder](https://github.com/jazminschroeder))
* 0.2.4 Correct leap-year dates handling (thanks [BastienDuplessier](https://github.com/BastienDuplessier))
* 0.2.5 Added German locale (thanks [contradictioned](https://github.com/contradictioned))

## Roadmap

1. Rdoc/YARD coverage of everything

2. Other ORMs support (DataMapper, Sequel, Mongoid)

## Contributing

Fork the repository, push your changes to a topic branch and send me a pull request.
