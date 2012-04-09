require 'version.rb'

#require 'bootstraps_bootstraps/engine' if defined? ::Rails
require 'bootstraps_bootstraps/railtie.rb'

module BootstrapsBootstraps
  extend ::ActiveSupport::Autoload

  autoload :BootstrapFormBuilder
  autoload :BootstrapFormHelper
end
