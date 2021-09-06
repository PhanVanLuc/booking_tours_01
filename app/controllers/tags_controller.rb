class TagsController < ApplicationController
  before_action :load_tag, only: [:show, :edit, :update, :destroy]
  def new
    @tag = Tag.new
  end

  def index
    @tags = Tag.page(params[:page])
  end

  def show
  end

  def create
    @tag = Tag.new(tag_params) 
    if @tag.save
      flash[:success] = t("category.category.new")
      redirect_to tags_path
    else 
      flash[:success] = t("category.category.fail")
      redirect_to tags_path
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      flash[:success] = t("category.category.update")
      redirect_to tags_path
    else
      redirect_to tags_path
    end
  end

  def destroy
    if @tag.destroy
      flash[:success] = t("category.category.delete")
    else
      flash[:danger] = t("category.category.fail")
    end
    redirect_to tags_url
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
  def load_tag
    @tag = Tag.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = t("category.category.fail")
    redirect_to tags_path
  end 
end
