# Festivals Lab API #

An unofficial library to access festival data from the Edinburgh Festivals Innovation Lab API

## Description ##

Festivals Lab is an open data initiative which provides free access to the events of the 12 annual Edinburgh festivals.

The `festivals_lab` gem wraps the API and ties it with a Ruby bow

## Compatibility ##

* As an alpha, `festivals_lab` is only developed and tested against Ruby 1.9.3 (other rubies should work, but run the tests first).
* There are no external dependencies for use other than the Ruby standard library.

## Installation ##

Install festivals_lab like any other ruby gem:

    > gem install festivals_lab

Or, to use it in a project with Bundler, add this to your Gemfile:

    gem 'festivals_lab'

…and then run the bundle install command from your shell:

    > bundle

## Usage ##

To use the FestivalsLab API you will need an API key, which can be obtained from the [Festivals Lab website][gettingstarted].

The parameters for library method calls match the [official documentation][querying], with the following considerations:

* The `key` and `signature` parameters are automatically added for you based on your authentication details, so there is no need to supply those to each API call.
* All parameters should be passed as `String` or `Numeric` (e.g. `Integer` or `Float`), specifically `Date`s aren't converted into the API's expected format yet
* The library exclusively requests JSON responses from the API, and the `pretty` parameter is invalid.

  [gettingstarted]: http://api.festivalslab.com/documentation#gettingstarted
  [querying]: http://api.festivalslab.com/documentation#Querying the API

### Sample usage ###

    api = FestivalsLab.new("xxAPIAccessKeyxx", "xxAPISecretKeyxxxxAPISecretKeyxx")

    api.events # The first page of events (using the API's default of 25 per page)

    api.events(festival: 'book', size: 50, from: 100)

    api.events(festival: 'fringe', post_code: 'EH1', price_to: 5)

The library returns the data as returned from the API, run through a JSON parser

### License ###

This software is open source and is licensed under the MIT license.

See the LICENSE file for more details

### Contributing ###

See the CONTRIBUTING file
