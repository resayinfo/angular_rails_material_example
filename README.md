# Fantasy League Finder

[![Build Status](https://travis-ci.org/llhupp/angular_rails_material_example.png?branch=master)](https://travis-ci.org/llhupp/angular_rails_material_example?branch=master)

##About
Originally started as a fork of this [Cafe Townsend example](https://github.com/sectore/CafeTownsend-Angular-Rails), but quickly morphed into something completely different.

This app allows users to search for available fantasy leagues by multiple attributes.

##Demo
* http://fantasy-league-finder.herokuapp.com/

##Interesting Tech
*  [ Rails 4.1.2 ](https://github.com/rails/rails/tree/v4.2.1)
*  [ AngularJS v1.3.11 ](https://code.angularjs.org/1.3.8/docs/api)
*  [ Bootstrap Material Design 0.3.0 ](http://fezvrasta.github.io/bootstrap-material-design)
*  [ CanCanCan 1.9.2 ](https://github.com/cancancommunity/cancancan)
*  [ Mechanize ](https://github.com/sparklemotion/mechanize)

##Noteable Patterns
* Haml views with Angular tags are compiled and sent to the browser on initial page load. Then, json requests take over.
* Extensive query building for mixing attributes and joining table as needed.


##Local installation
1) Open Terminal

    git clone git://github.com/llhupp/angular_rails_material_example.git
    cd angular_rails_material_example
    bundle install --without production
    rake db:migrate
    rake db:seed
    rails s

2) Open [http://localhost:3000](http://localhost:3000/) using [Chrome](https://www.google.com/chrome)


##Tests

Note: Make sure that you have [PhantomJS](http://phantomjs.org/) installed on your machine.

    rake

##Author
Lyric Hupp