module BootstrapsBootstraps
  class Engine < ::Rails::Engine

    initializer 'bootstraps_bootstraps.initialize' do
      ActiveSupport.on_load :action_view do
        include BootstrapsBootstraps::BootstrapFormHelper
      end
    end

  end
end

