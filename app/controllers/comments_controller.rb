class CommentsController < ApplicationController
  load_and_authorize_resource
  before_filter :decode_commentable_type
  def index
    @commentable=params[:commentable_type].constantize.find(params[:commentable_id]) unless params[:commentable_type].nil? or params[:commentable_id].nil?
    @comments=@commentable.comments.order(:created_at).roots.accessible_by(current_ability, :show).page(params[:page]).per(Comment::NUM[params[:commentable_type]]).reverse_order
    respond_to do |format|
      format.js
    end
  end
  def hide
    @commentable=params[:commentable_type].constantize.find(params[:commentable_id]) unless params[:commentable_type].nil? or params[:commentable_id].nil?
    respond_to do |format|
      format.js
    end  
 end
  def show
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.js 
      format.html {redirect_to @comment.commentable}
    end
  end
  def new
   
    @comment = Comment.new
    @comment.commentable=params[:commentable_type].constantize.find(params[:commentable_id]) unless params[:commentable_type].nil? or params[:commentable_id].nil?
    authorize! :comment, @comment.commentable

    respond_to do |format|
      format.js
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    params_new= params[:comment].select {|i| !["commentable_id", "commentable_type"].include?(i)}

    c = params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id]) unless params[:comment][:commentable_type].nil? or params[:comment][:commentable_id].nil? 
    authorize! :comment, c
    
    @comment = Comment.build_for(c, current_user,"", params_new)  

    if @comment.parent_object.class==Comment
      @comments= @comment.parent_object.children
    else
      @comments=@comment.parent_object.comments.order(:created_at).roots.page(params[:page]).per(Comment::NUM[params[:commentable_type]]).reverse_order
    end
    respond_to do |format|
      if @comment
        format.js       
      else
        format.js {render action:"new"}
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    params[:comment].select! {|i| !["commentable_id", "commentable_type"].include?(i)}
    @comment = Comment.find(params[:id])
    @comment.commentable=params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id]) unless params[:comment][:commentable_type].nil? or params[:comment][:commentable_id].nil? 
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment.commentable, notice: 'Comment was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @commentable=@comment.commentable
    @comment.destroy
    @comments=@commentable.comments.order(:created_at).roots.page(params[:page]).per(Comment::NUM[params[:commentable_type]]).reverse_order
    respond_to do |format|
      format.js
    end
  end
  private
  def decode_commentable_type
    params[:commentable_type].gsub!("_","::") unless params[:commentable_type].nil?
  end
  
end
