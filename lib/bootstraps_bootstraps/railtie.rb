require 'ruby-debug'

module BootstrapsBootstraps
  class Railtie < Rails::Railtie
    initializer "bootstraps_bootstraps.configure_rails_initialization" do |application|
      # Prevent Rails from wrapping form elements with errors in <div class="field_with_error">
      # boxes.  Bootstrap has a bit of a different paradigm.
      # Credit where due: http://stackoverflow.com/questions/5267998/rails-3-field-with-errors-wrapper-changes-the-page-appearance-how-to-avoid-t
      application.config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    end

    config.to_prepare do
      #RELOAD THE GEM ALL THE TIME WITHOUT RESTARTING THE SERVER :O (without restarting the server)
      ::ActionView::Helpers.send(:load, 'bootstraps_bootstraps/bootstrap_form_builder.rb')
      ::ActionView::Helpers.send(:include, BootstrapsBootstraps::BootstrapFormHelper)
    end
  end
end
