module BootstrapsBootstraps
  module BootstrapFormHelper
    #merely setup the form_for to use our new form builder
    def bootstrapped_form object, options={}, &block
      options[:builder] = BootstrapFormBuilder
      form_for object, options, &block
    end
  end
end
