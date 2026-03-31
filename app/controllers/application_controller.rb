class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!, unless: :public_page?

  private

  def public_page?
    controller_name == "home" && action_name == "show"
  end

  def after_sign_in_path_for(resource)
    root_path
  end
  
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
end
