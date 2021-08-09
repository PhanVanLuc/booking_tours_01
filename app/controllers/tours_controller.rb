class ToursController < ApplicationController
  before_action :load_tour, only: [:show, :update, :destroy, :edit]
  def index
    @tours = Tour.search(params[:term]).paginate(page: params[:page])
  end
  def new
    @tour=Tour.new
  end
  def create
    @tour = Tour.new(tour_params) 
    if @tour.save
      flash[:success] = t("tour.tour.new")
      redirect_to @tour
    else 
      render :new
    end
  end
  def show
  end
  def edit
  end
  def update
    if @tour.update(tour_params)
      flash[:success] = t("tour.tour.updated")
      redirect_to @tour
    else
      render :edit
    end
  end
  def destroy
    if @tour.destroy
      flash[:success] = t("tour.tour.deleted")
    else
      flash[:danger] = t("tour.tour.fail")
    end
    redirect_to tours_url
  end
  def tour_params
    params.require(:tour).permit(:tour_name, :description, :status, :tour_amount, :date_begin, :date_end, :price)
  end
  private
    # Find a tour
    def load_tour
      @tour = Tour.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = t("tour.tour.fail")
      redirect_to root_url
    end
end