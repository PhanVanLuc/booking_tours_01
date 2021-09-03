class CategoriesController < ApplicationController
  before_action :load_category, only: [:show, :edit, :update, :destroy]
  before_action :set_category, only: [:new, :edit]
  def new
    @category = Category.new
  end

  def index
    @categories = Category.page(params[:page])
  end

  def show
  end

  def create
    if (params[:parent_id_2]=="")
      @category = Category.new(category_params)
    else
      @category = Category.new(category_name: category_params[:category_name], 
                                parent_id: params[:parent_id_2])
    end
    if @category.save
      flash[:success] = t("category.category.new")
      redirect_to categories_path
    else 
      flash[:success] = t("category.category.fail")
    end
  end

  def by_parent
    render json: { categories: Category.where(parent_id: params[:parent_id]) }
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:success] = t("category.category.update")
      redirect_to categories_path
    else
      redirect_to categories_path
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t("category.category.delete")
    else
      flash[:danger] = t("category.category.fail")
    end
    redirect_to categories_url
  end

  def category_params
    params.require(:category).permit(:category_name, :parent_id)
  end

  def set_category
    @categories = Category.all.pluck(:category_name, :id)
  end

  def load_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = t("category.category.fail")
    redirect_to categories_path
  end 
end
