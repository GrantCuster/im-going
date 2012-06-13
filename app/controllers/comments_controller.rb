class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.build(params)
    @comment.save
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @comment }
    end
  end  

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { render 'listings/feed' }
      format.json { render :json => @comment }
    end
  end
  
end