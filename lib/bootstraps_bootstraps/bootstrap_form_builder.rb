module ActionView
  module Helpers
    module FormHelper

      def wrapped_inputs object_name, object = nil, options = {}, wrapper, &block
        builder = instantiate_builder(object_name, object, options, &block)
        fields = capture(builder, &block)
        wrapper.call(fields)
      end

    end
  end
end


module BootstrapsBootstraps
  #
  #  This class started out as a gist somewhere but I can't seem to find the
  #  original.  At any rate its been modified over time to make it not break
  #  and to update it to make it compatible with Bootstrap2.
  #
  #  If I'm being brutally honest its a bit of a cluster of metaprogramming
  #  and it can be pretty difficult to understand.  BUT it does seem to work
  #  so far.
  #
  class BootstrapFormBuilder < ActionView::Helpers::FormBuilder

    delegate :capture, :content_tag, :tag, to: :@template

    def initialize(object_name, object, template, options, block)
      super(object_name, object, template, options, block)

      @form_mode = :vertical   #default value
      @form_mode = :horizontal if options[:horizontal] || detect_html_class(options, 'form-horizontal')
      @form_mode = :search     if options[:search]     || detect_html_class(options, 'form-search')
      @form_mode = :inline     if options[:inline]     || detect_html_class(options, 'form-inline')
    end

    %w[text_field text_area password_field number_field telephone_field url_field email_field range_field collection_select].each do |method_name|
      define_method(method_name) do |name, *args|
        options = args.extract_options!

        #abort and just let the rails formbuilder do its thing
        if options[:vanilla]
          return super(name, *(args.push(options)))
        end

        errors = object.errors[name].any? ? 'error' : ''
        error_msg = object.errors[name].any? ? content_tag(:span, object.errors[name].join(","), class: 'help-inline') : ''

        help_text =  options[:help_text].blank? ? '' : content_tag(:span,options[:help_text], class: 'help-block')

        label = options[:label] == false ? ''.html_safe : field_label(name, options.except(:class))

        options[:class] = [options[:class]] unless options[:class].kind_of?(Array)
        options[:class].push 'xxlarge' if options[:large] || method_name == 'text_area'
        options[:class].push 'inline' if @form_mode == :inline

        args.push(options).unshift(name)

        field = super(*args) + ' ' + error_msg

        #wrap it in div.controls
        field = div_with_class(['controls',errors], :content => field) if @form_mode == :horizontal

        #tack on the label
        field = label + field unless @form_mode == :inline

        #wrap it in div.control-group
        field = div_with_class(['control-group',errors], :content => field) if @form_mode == :horizontal

        field
      end
    end

    #TODO update for bootstrap 2
    def check_box(name, *args)
      if options[:vanilla]
        return super *args
      end

      options = args.extract_options!
      if options.has_key? :class
        unless options[:class].kind_of? Array
          options[:class] = [options[:class]]
        end
      else
        options[:class] = []
      end

      options[:class].push :checkbox

      text = options[:label] || ''
      options.delete :label

      args = args.push options

      field_label(name, *args) do
        super(name, *args) + text
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

    def inline_inputs field_options = {}, &block
      field_options[:inline] = true
      wrapper = lambda { |content|
        field_group = div_with_class('controls', content: content)
        field_group = label( field_options[:label], field_options[:label], class: 'control-label' ) + field_group
        field_group = div_with_class('control-group', content: field_group)
      }
      @template.wrapped_inputs(@object_name, @object, @options.merge(field_options), wrapper, &block)
    end

  private

    def field_label(name, *args, &block)
      options = args.extract_options!
      clss = options[:class] || []

      required = object.class.validators_on(name).any? { |v| v.kind_of? ActiveModel::Validations::PresenceValidator}
      clss.push 'required' if required


      label(name, options[:label], class: clss, &block)
    end

    def objectify_options(options)
      super.except(:label)
    end

    def detect_html_class options_hash, css_class
      if options[:html] && options[:html][:class]
        if options[:html][:class].kind_of? Array
          options[:html][:class].include css_class
        elsif options[:html][:class].kind_of? String
          options[:html][:class] == css_class
        else
          false
        end
      else
        false
      end
    end

    def div_with_class clss, options = {}, &block
      options[:class] = [options[:class]] || []
      options[:class].push clss

      classes = options[:class].join(' ').strip

      if block_given?
        content_tag :div, :class => classes, &block
      elsif options[:content]
        content_tag :div, :class => classes do
          options[:content]
        end
      else
        content_tag :div, :class => classes do
        end
      end
    end


  end
end
