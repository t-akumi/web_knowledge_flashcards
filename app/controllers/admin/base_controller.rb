module Admin
    class BaseController < ApplicationController
      before_action :require_admin!
  
      private
  
      def require_admin!
        return if user_signed_in? && current_user.admin?
        redirect_to root_path, alert: "権限がありません"
      end
    end
end
  