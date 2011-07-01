# -*- encoding : utf-8 -*-
#
# Filters added to this controller apply to all controllers in the hosting application
# as this module is mixed-in to the application controller in the hosting app on installation.
module Blacklight::Controller 

  def self.included(base)
    base.send :before_filter, :default_html_head # add JS/stylesheet stuff
    # now in application.rb file under config.filter_parameters
    # filter_parameter_logging :password, :password_confirmation 
    base.send :helper_method, :current_user_session, :current_user
    base.send :after_filter, :discard_flash_if_xhr    

    # handle basic authorization exception with #access_denied
    base.send :rescue_from, Blacklight::Exceptions::AccessDenied, :with => :access_denied
    
    base.send :helper_method, [:request_is_for_user_resource?]#, :user_logged_in?]
    
    base.send :layout, :choose_layout

    # extra head content
    base.send :helper_method, :extra_head_content
    base.send :helper_method, :stylesheet_links
    base.send :helper_method, :javascript_includes
  end

  
    # test for exception notifier plugin
    def error
      raise RuntimeError, "Generating a test error..."
    end
    
    #############
    # Display-related methods.
    #############
    
    # before filter to set up our default html HEAD content. Sub-class
    # controllers can over-ride this method, or instead turn off the before_filter
    # if they like. See:
    # http://api.rubyonrails.org/classes/ActionController/Filters/ClassMethods.html
    # for how to turn off a filter in a sub-class and such.
    def default_html_head
      if use_asset_pipeline?
        stylesheet_links  << ["application"]
        javascript_includes << ["application"]
      else
        stylesheet_links << ['yui', 'jquery/ui-lightness/jquery-ui-1.8.1.custom.css', 'blacklight/blacklight', {:media=>'all'}]
      
        javascript_includes << ['jquery-1.4.2.min.js', 'jquery-ui-1.8.1.custom.min.js', 'blacklight/blacklight' ]
      end
    end
    
    
    # An array of strings to be added to HTML HEAD section of view.
    # See ApplicationHelper#render_head_content for details.
    def extra_head_content
      @extra_head_content ||= []
    end

    
    # Array, where each element is an array of arguments to
    # Rails stylesheet_link_tag helper. See
    # ApplicationHelper#render_head_content for details.
    def stylesheet_links
      @stylesheet_links ||= []
    end
    
    # Array, where each element is an array of arguments to
    # Rails javascript_include_tag helper. See
    # ApplicationHelper#render_head_content for details.
    def javascript_includes
      @javascript_includes ||= []
    end
    
    protected

    # Returns a list of Searches from the ids in the user's history.
    def searches_from_history
      session[:history].blank? ? [] : Search.where(:id => session[:history]).order("updated_at desc")
    end
    
    #
    # Controller and view helper for determining if the current url is a request for a user resource
    #
    def request_is_for_user_resource?
      request.env['PATH_INFO'] =~ /\/?users\/?/
    end

    #
    # If a param[:no_layout] is set OR
    # request.env['HTTP_X_REQUESTED_WITH']=='XMLHttpRequest'
    # don't use a layout, otherwise use the "application.html.erb" layout
    #
    def choose_layout
      layout_name unless request.xml_http_request? || ! params[:no_layout].blank?
    end
    
    #over-ride this one locally to change what layout BL controllers use, usually
    #by defining it in your own application_controller.rb
    def layout_name
      'blacklight'
    end

    def current_user_session
      puts "DEPRICATED:  Please use Devise, Authlogic or other authentication system."
      user_session  # method provided by devise
    end

    # Should be provided by devise
    # def current_user
    # end
    
    ##
    # We discard flash messages generated by the xhr requests to avoid
    # confusing UX.
    def discard_flash_if_xhr
      flash.discard if request.xhr?
    end

    ##
    # To handle failed authorization attempts, redirect the user to the 
    # login form and persist the current request uri as a parameter
    def access_denied
      # send the user home if the access was previously denied by the same
      # request to avoid sending the user back to the login page
      #   (e.g. protected page -> logout -> returned to protected page -> home)
      redirect_to root_url and flash.discard and return if request.referer and request.referer.ends_with? request.fullpath

      redirect_to new_user_session_url(:referer => request.fullpath)
    end
  
    private
    # Detect if the Rails asset pipeline is enabled
    def use_asset_pipeline?
      Rails.application.config.respond_to?(:assets) and Rails.application.config.assets.enabled
    end
end

