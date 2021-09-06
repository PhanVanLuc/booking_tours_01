class StaticPagesController < ApplicationController
  before_action :load_review_category, only: [:reviewfood, :reviewplace]
  before_action :load_tag, only: :home
  def home
    @newtours = Tour.last(3)
    @populartours = Tour.first(6)
  end
  
  def thanks
  end
  
  def reviewfood()
  end

  def reviewplace()
  end

  private
    def load_review_category
      @reviews  = Category.find(params[:id]).reviews
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t("review.review.fail")
        redirect_to reviews_path   
    end
end
