##Bootstraps_bootstraps

[Bootstrap 2.0](http://twitter.github.com/bootstrap/) is Twitter's CSS and Javascript framework.  It is a great baseline for starting web applications.  As a CSS/Javascript framework it does a great job of providing a baseline styleset and group of user interface components given that you play within its garden.

[Rails 3](http://rubyonrails.org/) is an open source web framework that does a lot to make web application development easy, secure, and quick.

To get the best experience out of both worlds Rails needs a bit of bootstrapping to get a form builder that plays nice with Bootstrap.  This gem provides the bootstraps that Bootstrap needs to make Rails+Bootstrap a potent combination.

##Current Features

An extended form_for called `bootstrap_form` with all the classic functionality yet extended to provide correct Bootstrap 2 syntax for horizontal forms (classed with .form_horizontal) for most elements.

##Development Strategy

More or less I'm writing this library as needed.  Each time I find myself trying to do something with form_for or interact between Rails and Bootstrap I find a way to make them play nice together without losing baseline Rails functionality.

Things that I know aren't in the library yet:

 - Collection methods (select box, check boxes, radio buttons)
 - Check boxes in general
 - Full implementation of an optional attribute to make bootstrapped_form silence and revert to the default for a specific form field
 - .form-vertical, .form-search, and .form-inline specific html syntax

##Use

Add this to your gemfile: `gem 'bootstraps_bootstraps', git: 'git@github.com:robacarp/bootstraps_bootstraps.git'`

To use the bootstrap form helper in your views:

```ruby
= bootstrapped_form @user do |f|
  = f.text_field :first_name
  = f.text_field :last_name
  = f.collection_select :occupations, Occupation.all, :id, :name, :label => 'Job'
  = f.text_field :address,  :label => "Address Line 1"
  = f.text_field :address2,  :label => "Line 2"
  = f.submit ("Shipping Options &rarr;").html_safe, :class=>'fright'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
6. :-)
