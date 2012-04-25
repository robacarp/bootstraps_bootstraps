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

      @action_wrapped = options[:action_wrapped]
    end


    #the main method constructor which takes care of most of the use cases
    %w[text_field text_area password_field number_field telephone_field url_field email_field range_field file_field].each do |method_name|
      define_method(method_name) do |name, *args|
        options = args.extract_options!

        #abort and just let the rails formbuilder do its thing
        if options[:vanilla]
          return super(name, *(args.push(options)))
        end

        errors, error_msg = render_errors name

        label_options = options.clone
        label_options[:class] = options[:label_class] unless options[:label_class].nil?
        guarantee_html_class label_options, 'control-label'
        label = options[:label] == false ? ''.html_safe : field_label(name, label_options)

        guarantee_html_class options
        options[:class].push 'input-xlarge' if options[:large] || method_name == 'text_area'
        options[:class].push 'inline' if @form_mode == :inline

        options.delete :label
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

    def check_box method, options = {}, checked_value = 1, unchecked_value = 0
      if options[:vanilla]
        return super
      end

      guarantee_html_class options, :checkbox
      options[:class].push 'inline' if @form_mode == :inline

      text = options[:label] || ''
      options.delete :label

      #TODO provide support for grouped checkboxes
      div_with_class 'control-group' do
        div_with_class 'controls' do
          field_label(method, options) do
            super(method,options,checked_value,unchecked_value)  + text
          end
        end
      end
    end

    def collection_select method, collection, value_method, text_method, options = {}, html_options = {}
      #abort and just let the rails formbuilder do its thing
      if options[:vanilla]
        return super
      end

      errors, error_msg = render_errors method

      label_options = options.clone
      guarantee_html_class label_options, 'control-label'
      label = options[:label] == false ? ''.html_safe : field_label(method, label_options)

      guarantee_html_class options
      options[:class].push 'input-xlarge' if options[:large]
      options[:class].push 'inline' if @form_mode == :inline

      options.delete :label

      field = super(method,collection,value_method,text_method,options,html_options) + ' ' + error_msg

      #wrap it in div.controls
      field = div_with_class(['controls',errors], :content => field) if @form_mode == :horizontal

      #tack on the label
      field = label + field unless @form_mode == :inline

      #wrap it in div.control-group
      field = div_with_class(['control-group',errors], :content => field) if @form_mode == :horizontal

      field
    end

    def date_select method, options = {}, html_options = {}
      field = super

      return field if options[:vanilla]

      errors, error_msg = render_errors method

      #hmm, apparently TODO
      help_text options

      label_options = html_options.clone
      label_options[:class] = ['control-label']
      #guarantee_html_class label_options, 'control-label'
      label = options[:label] == false ? ''.html_safe : field_label(method, label_options)

      guarantee_html_class html_options, 'inline'

      field += ' '.html_safe + error_msg
      field = div_with_class(['controls',errors], :content => field) if @form_mode == :horizontal
      field = label + field
      field = div_with_class(['control-group',errors], :content => field) if @form_mode == :horizontal
      field
    end

    def radio_button method, value, options = {}
      guarantee_html_class options, 'radio'
      error_class, error_message = render_errors method

      text = options[:label] || ''
      options.delete :label

      content_tag(:label, class: options[:class]) do
        super(method,value,options) + text
      end
    end

    def submit text = nil, options = {}
      # options block gets stringify_keys called on it in the first super, no :keys exist after that
      field = super
      return field if options['vanilla']
      field = div_with_class('form-actions', content: field) unless options['no_action_block'] || @action_wrapped || [:inline, :search].include?(@form_mode)
      field
    end


    #input groups
    def inline_inputs field_options = {}, &block
      field_options[:inline] = true
      wrapper = lambda { |content|
        field_group = div_with_class('controls', content: content)
        field_group = label( field_options[:label], field_options[:label], class: 'control-label' ) + field_group
        field_group = div_with_class('control-group', content: field_group)
      }
      @template.wrapped_inputs(@object_name, @object, @options.merge(field_options), wrapper, &block)
    end

    def grouped_inputs field_options = {}, &block
      wrapper = lambda do |content|
        field_group = div_with_class('controls', content:content)
        if field_options[:label]
          field_group = label( field_options[:label], field_options[:label], class: 'control-label') + field_group
        end
        field_group = div_with_class('control-group', content:field_group)
      end

      @template.wrapped_inputs(@object_name, @object, @options, wrapper, &block)
    end

    def form_actions field_options = {}, &block
      field_options[:action_wrapped] = true
      wrapper = lambda { |content|
        field_group = div_with_class('form-actions', content: content)
      }

      @template.wrapped_inputs(@object_name, @object, @options.merge(field_options), wrapper, &block)
    end

  private

    def field_label(name, options = {}, &block)
      guarantee_html_class options
      clss = options[:class]
      clss.push 'required' if object.class.validators_on(name).any? { |v| v.kind_of? ActiveModel::Validations::PresenceValidator}

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

    def guarantee_html_class options_hash, *new_classes
      if options_hash[:class].nil?
        options_hash[:class] = []
      elsif options_hash[:class].kind_of?(Symbol)|| options_hash[:class].kind_of?(String)
        options_hash[:class] =  [ options_hash[:class] ]
      end

      unless new_classes.empty?
        new_classes.each do |clss|
          options_hash[:class].push clss
        end
      end

      options_hash
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

    def render_errors method
      if object.nil?
        return ['','']
      end

      errors = object.errors[method].any? ? 'error' : ''
      error_msg = object.errors[method].any? ? content_tag(:span, object.errors[method].join(","), class: 'help-inline') : ''

      [errors, error_msg]
    end

    def help_text options
      options[:help_text].blank? ? '' : content_tag(:span,options[:help_text], class: 'help-block')
    end
  end
end
