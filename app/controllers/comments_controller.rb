class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:destroy, :hidden]
  before_action :load_comments, only: [:hidden, :destroy]
  def index
    @comments = Comment.page(params[:page]).per(Settings.Paginate.tours_per_page)
  end

  def new
    begin
      @review = Review.all.find(params[:review_id])
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t("review.review.fail")
        redirect_to reviews_path
    end
    @comment = @review.comments.new(parent_id: params[:parent_id])
  end
  
  def create
    begin
      @review = Review.all.find(params[:review_id])
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t("review.review.fail")
        redirect_to reviews_path
    end
    @comment = @review.comments.create(user_id: current_user.id, 
                                       cmt_content: comment_params[:cmt_content], 
                                       parent_id: comment_params[:parent_id])
    if @comment.save
      Notification.new(sender_id: current_user.id,
        content: "#{current_user.name} đã bình luận về bài #{@review.review_name}",
        receiver_id: @review.user_id,
        target_uri: review_path(@review.id))
        .save
      redirect_to review_path(@review.id)
    else
      flash[:danger] = t("review.show.fail")
      redirect_to review_path(@review.id)
    end
  end

  def destroy
    if @comment.destroy
      flash[:success] = t("category.category.delete")
    else
      flash[:danger] = t("category.category.fail")
    end
    redirect_to comments_url
  end

  def hidden
    @comment.status=!@comment.status;
    @comment.save;
    redirect_to comments_path
  end
  
  private
    def comment_params
      params.require(:comment).permit(:parent_id,:cmt_content,:parent_id)
    end

    def load_comments
      @comment = Comment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = t("review.review.fail")
        redirect_to comments_path
    end

end