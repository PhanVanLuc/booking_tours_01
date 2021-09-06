class ToursController < ApplicationController
  before_action :load_tour, only: [:show, :update, :destroy, :edit]
  before_action :admin_user, only: [:destroy, :create, :edit, :update]
  before_action :load_tag, only: [:index, :searchtag]
  before_action :set_tag, only:[:edit, :new, :create, :update]
  def index
    tours_index_helper
  end

  def new
    @tour=Tour.new
  end

  def create
    @tour = Tour.new(tour_params) 
    if @tour.save
      SendEmailNewTourJob.set(wait: 2.minutes).perform_later @tour
      flash[:success] = t("tour.index.new")
      redirect_to @tour
    else 
      render :new
    end
  end

  def show
    if logged_in?
      @rating = Rating.find_by(user_id: current_user.id, tour_id: params[:id])
    end
    count = @tour.ratings.count
    @avg = count > 0 ? (@tour.ratings.sum(:stars) / count.to_f) : 0
  end

  def edit
  end

  def update
    if @tour.update(tour_params)
      flash[:success] = t("tour.index.updated")
      redirect_to admin_tours_path
    else
      render :edit
    end
  end

  def destroy
    if @tour.destroy
      flash[:success] = t("tour.index.deleted")
    else
      flash[:danger] = t("tour.index.fail")
    end
    redirect_to admin_tours_path
  rescue ActiveRecord::InvalidForeignKey
    flash[:danger] = t("tour.index.fail")
    redirect_to admin_tours_path
  end

  def searchtag
    @tours=Tour.where(tag: params[:id] ).page(params[:page]).per(Settings.Paginate.tours_per_page)
    StatisticTag.new(tag_id:params[:id]).save
  end

  private
    # Find a tour
    def load_tour
      @tour = Tour.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t("tour.index.fail")
        redirect_to root_url
    end

    def tour_params
      params.require(:tour).permit(:tour_name, :description, :status, :tour_amount, :time, :price, :tag,images: [])
    end

    def set_tag
      @tags = Tag.all.pluck(:name, :id)
    end
end
