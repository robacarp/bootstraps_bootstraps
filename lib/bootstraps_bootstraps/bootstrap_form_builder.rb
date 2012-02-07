module BootstrapsBootstraps
  class BootstrapFormBuilder < ActionView::Helpers::FormBuilder

    delegate :capture, :content_tag, :tag, to: :@template

    #
    #  This method started out as a gist somewhere but I can't seem to find the
    #  original.  At any rate its been modified over time to make it not break
    #  and to update it to make it compatible with Bootstrap2.
    #
    #  If I'm being brutally honest its a bit of a cluster of metaprogramming
    #  and it can be pretty difficult to understand.  BUT it does seem to work
    #  so far.
    #
    %w[text_field text_area password_field collection_select].each do |method_name|
      define_method(method_name) do |name, *args|
        options = args.extract_options!

        if options[:vanilla]
          return super(name, *(args.push(options)))
        end

        errors = object.errors[name].any? ? 'error' : ''
        error_msg = object.errors[name].any? ? content_tag(:span, object.errors[name].join(","), class: 'help-inline') : ''

        help_text =  options[:help_text].blank? ? '' : content_tag(:span,options[:help_text], class: 'help-block')
        label = options[:label] == '' ? ''.html_safe : field_label(name, options)

        if options[:large] || method_name == 'text_area'
          options[:class] = [options[:class]] || []
          options[:class].push 'xxlarge'
        end

        content_tag :div, class: "control-group #{errors}" do
          label + content_tag(:div, class: "controls #{errors}") do
            super(name, *(args.push(options))) + ' ' + error_msg
          end + help_text
        end
      end
    end

    #TODO update for bootstrap 2
    def check_box(name, *args)
      content_tag :div, class:"clearfix" do
        content_tag(:div, class:"input") do
          content_tag(:ul, class:"inputs-list") do
            content_tag(:li) do
              content_tag(:label) do
                super(name, *args) + content_tag(:span) do
                  field_label(name, *args)
                end
              end
            end
          end
        end
      end
    end

    def submit *args
      options = args.extract_options!
      args = args.push options

      if options[:vanilla]
        super *args
      else
        content_tag :div, class: 'form-actions' do
          super *args
        end
      end

    end

  private

    def field_label(name, *args)
      options = args.extract_options!
      required = object.class.validators_on(name).any? { |v| v.kind_of? ActiveModel::Validations::PresenceValidator}
      label(name, options[:label], class: ("required" if required))
    end

    def objectify_options(options)
      super.except(:label)
    end

  end
end
