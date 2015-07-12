 class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_i18n_locale_from_params
  protected
  theme :get_theme 
  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale=params[:locale].to_sym
      else
        flash.now[:notice]= "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    else
      I18n.locale = session[:locale] || :de
    end
    session[:locale] = I18n.locale
  end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_path(:only_path => false, :protocol => 'http')
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || root_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    
    if user_signed_in?
      flash[:error] = "Not authorized to view this page"
      session[:user_return_to] = nil
      redirect_to root_url

    else              
      flash[:error] = "You must first login to view this page"
      session[:user_return_to] = request.url
      redirect_to "/users/sign_in"
    end 
    
  end 
  def get_theme
u=current_user
 if ! u.try(:preferredtheme).nil? and ThemesForRails.available_theme_names.include?(u.preferredtheme) 
      u.preferredtheme
  else
    "blue1"
  end

  end

def current_ability
 @current_ability ||= Ability.new(current_user, request, params[:key])
end
  def default_url_options
    {locale: nil, theme: nil , ansicht: nil} # I18n.locale
  end
end
