module BootstrapsBootstraps
  class Railtie < Rails::Railtie
    initializer "bootstraps_bootstraps.configure_rails_initialization" do |application|
      #Disable the Rails default field_with_errors div wrapper.
      application.config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    end
  end
end

require 'bootstraps_bootstraps' if defined?(Rails)
