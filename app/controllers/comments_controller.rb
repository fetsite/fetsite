class CommentsController < ApplicationController
  def index
    @commentable=params[:commentable_type].constantize.find(params[:commentable_id]) unless params[:commentable_type].nil? or params[:commentable_id].nil?
    @comments=@commentable.comments.order(:created_at).roots.page(params[:page]).per(2).reverse_order
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
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
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end
  def new
    @comment = Comment.new
    @comment.commentable=params[:commentable_type].constantize.find(params[:commentable_id]) unless params[:commentable_type].nil? or params[:commentable_id].nil?
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
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
    
    @comment = Comment.build_for(c, current_user,"", params_new)  
    respond_to do |format|
      if @comment
        format.html { redirect_to @comment.commentable, notice: 'Comment was successfully created.', show_comments: true }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
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
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @commentable=@comment.commentable
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, :action=>"show"}
      format.json { head :no_content }
    
    end
  end
end
