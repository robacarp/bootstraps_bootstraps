##Bootstraps_bootstraps

[Bootstrap 2.0](http://twitter.github.com/bootstrap/) is Twitter's CSS and Javascript framework.  It is a great baseline for starting web applications.  As a CSS/Javascript framework it does a great job of providing a baseline styleset and group of user interface components given that you play within its garden.

[Rails 3](http://rubyonrails.org/) is an open source web framework that does a lot to make web application development easy, secure, and quick.

To get the best experience out of both worlds Rails needs a bit of bootstrapping to get a form builder that plays nice with Bootstrap.  This gem provides the bootstraps that Bootstrap needs to make Rails+Bootstrap a potent combination.

Development of this gem more or less follows [Bootstrap-sass](https://github.com/thomas-mcdonald/bootstrap-sass).  As such the version number of this project correspond to the Twitter Bootstrap version numbers for both the Major and Minor.  The Patch number will track independently.

##Current Features

An extended form_for called `bootstrap_form` with all the classic functionality yet extended to provide correct Bootstrap 2 syntax for horizontal forms (classed with .form_horizontal) for most elements.

##Development Strategy

This isn't compatible with Bootstrap versions < 2.

More or less I'm writing this library as needed.  Each time I find myself trying to do something with form_for or interact between Rails and Bootstrap I find a way to make them play nice together without losing baseline Rails functionality.

Things that I know aren't in the library yet:

 - Collection methods (select box, check boxes, radio buttons)

##Use

Add it to your gemfile: `gem 'bootstraps_bootstraps'`

To use the Bootstrap 2 form helper in your views:

```ruby

# set the form class as you would for the Bootstrap library.  Bootstraps_bootstraps will use that to determine the html elements required.
= bootstrapped_form @user, html: {class: 'form-horizontal'} do |f|
  # Labels are added automatically
  = f.text_field :first_name
  = f.text_field :last_name

  # Override the label text with :label in the options hash
  = f.collection_select :occupations, Occupation.all, :id, :name, :label => 'Job'
  = f.text_field :address,  :label => "Address Line 1"
  = f.text_field :address2,  :label => "Line 2"

  #make an inline field group inside of the horizontal form
  = f.inline_inputs label: 'Expiration Date' do |inline|
    = inline.collection_select :month, (1..12), :to_s, :to_s
    \-
    = inline.collection_select :year, (Time.now.year...Time.now.year + 10), :to_s, :to_s

  = f.submit
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
6. :-)
