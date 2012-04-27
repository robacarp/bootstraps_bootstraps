require 'version.rb'

#require 'bootstraps_bootstraps/engine' if defined? ::Rails
require 'bootstraps_bootstraps/railtie.rb'

module BootstrapsBootstraps
  extend ::ActiveSupport::Autoload

  autoload :BootstrapFormBuilder
  autoload :BootstrapFormHelper
end

::ActionView::Helpers.send(:load, 'bootstraps_bootstraps/bootstrap_form_builder.rb')
::ActionView::Helpers.send(:load, 'bootstraps_bootstraps/bootstrap_form_helper.rb')
::ActionView::Helpers.send(:include, BootstrapsBootstraps::BootstrapFormHelper)
