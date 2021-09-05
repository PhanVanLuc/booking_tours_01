class ReviewsController < ApplicationController
  before_action :logged_in_user, only:[:edit, :new, :create, :update, :index, :like]
  before_action :set_category, only:[:edit, :new, :create, :update]
  before_action :load_review, only: [:edit, :update, :destroy, :hidden]

  def index
    if current_user.admin?
      @reviews = Review.page(params[:page]).per(Settings.Paginate.tours_per_page)
    else
      @reviews = Review.filter(current_user.id).page(params[:page]).per(Settings.Paginate.tours_per_page)
    end
  end

  def new
    @review = Review.new
  end
  def show
    begin
      @review = Review.all.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t("review.review.fail")
        redirect_to reviews_path
    end
    @author= @review.user
  end

  def create
    @review = current_user.reviews.create(review_params)    
    if @review.save
      flash[:success] = t("review.review.new")
      redirect_to reviews_path
    else 
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash[:success] = t("review.review.updated")
      redirect_to reviews_path
    else
      render :edit
    end
  end

  def destroy
    if @review.destroy
      flash[:success] = t("review.review.deleted")
    else
      flash[:danger] = t("review.review.fail")
    end
    redirect_to reviews_url
  end

  def hidden
    @review.status=!@review.status;
    @review.save;
    redirect_to reviews_path
  end

  def like
    begin
      @review=Review.all.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t("review.review.fail")
        redirect_to review_path(@review)
    end
    if @review.liked? current_user
      user_dislike
    else
      user_like
    end
    redirect_to review_path(@review)
  end
  
  private
    def review_params
      params.require(:review).permit(:review_name, :review_content, :image, :category_id)
    end

    def load_review
      if (current_user.admin?)
        @review = Review.all.find(params[:id])
      else
        begin
          @review = current_user.reviews.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            flash[:danger] = t("review.review.fail")
            redirect_to reviews_path
        end
      end
    end

    def user_dislike
      LikeReview.find_by(review_id: params[:id], user_id: current_user.id).destroy!
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t("review.review.fail")
    end

    def user_like
      LikeReview.create(review_id:@review.id, user_id:current_user.id)
      Notification.new(sender_id: current_user.id, 
                        content: "#{current_user.name} đã like bài #{@review.review_name}", 
                        receiver_id: @review.user_id,
                        target_uri: review_path(@review.id)).save
    end
    
    def set_category
      @categories = Category.all.pluck(:category_name, :id)
    end
end