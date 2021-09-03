class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :category_menu
  include SessionsHelper
  
  private

    def tours_index_helper
      if params[:term]
        if (params[:page].blank?)
          @tours = Tour.search params[:term], page: Settings.Paginate.default_page, per_page: Settings.Paginate.tours_per_page
        else
          @tours = Tour.search params[:term], page: params[:page], per_page: Settings.Paginate.tours_per_page
        end
      else
        @tours = Tour.page(params[:page])
      end
    end
  
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t("users.edit.danger")
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = t("users.shared.not_right")
      redirect_to root_url
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    # Strong parameters
    def user_params
      params.require(:user).permit(:name, :email, :address,
                                   :phone_number, :date_of_birth,
                                   :password, :password_confirmation)
    end

    # Find a booking
    def load_booking
      @booking = current_user.bookings.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = t("bookings.shared.not_found")
      redirect_to root_url
    end

    # i18n method
  
    def default_url_options
      { locale: I18n.locale }
    end
    
    def set_locale
      I18n.locale = extract_locale || I18n.default_locale
    end
    
    def extract_locale
      parsed_locale = params[:locale]
      if I18n.available_locales.map(&:to_s).include?(parsed_locale)
        parsed_locale.to_sym
      end
    end
    
    def category_menu
      @category_items = Category.where(parent_id: nil)
    end
    
end
