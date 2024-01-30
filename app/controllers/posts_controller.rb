# app/controllers/posts_controller.rb

class PostsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create ,:destroy ,:update]
    before_action :set_post, only: [:show, :update, :destroy]
    def index
      @posts = JSON.parse(RestClient.get('https://jsonplaceholder.typicode.com/posts'))
      #render json: @posts
      respond_to do |format|
        format.html # Renders views/posts/index.html.erb
        format.json { render json: @posts }
      end
    end
  
    def show
      render json: @post
    end
  
    # def create
    #   @post = Post.new(post_params)
  
    #   respond_to do |format|
    #     if @post.save
    #       format.html { redirect_to post_path(@post), notice: 'Post was successfully created.' }
    #     else
    #       format.html { render :new }
    #     end
    #   end
    # end
    # def create
    #   @post = Post.new(post_params)
    #   # if @post.save
    #   #   render json: @post, status: :created, location: @post
    #   # else
    #   #   render json: {errors: @post.errors.full_messages}, status: :unprocessable_entity
    #   # end
    #   if @post.save
    #     redirect_to post_path(@post), notice: 'Post was successfully created.'
    #   else
    #     render :new
    #   end
    # end
    def create
      post_params = params[:post]
    
      response = RestClient.post(
        'https://jsonplaceholder.typicode.com/posts',
        { title: post_params[:title], body: post_params[:body] },
        accept: :html
      )
    
      flash[:notice] = 'Post was successfully created.'
      redirect_to post_path(JSON.parse(response.body)['id'])
    end

    # def create
    #   response = RestClient.post(
    #     'https://jsonplaceholder.typicode.com/posts',
    #     { title: params[:post][:title], body: params[:post][:body] },
    #     accept: :html
    #   )
  
    #   if response.code == 200
    #     flash[:notice] = 'Post was successfully created.'
    #     redirect_to post_path(JSON.parse(response.body)['id'])
    #   else
    #     flash.now[:alert] = 'Failed to create post.'
    #     @post = Post.new(post_params) # Rebuild the @post object for re-rendering the form
    #     render :new
    #   end
    # end
  
    def update
      if @post.update(post_params)
        render json: @post
      else
        render json: {errors: @post.errors.full_messages}, status: :unprocessable_entity
      end
    end
  
    def destroy
      @post.destroy
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
      #@post = Post.find(params[:id].to_i + 404)

    end
  
    def post_params
      params.require(:post).permit(:title, :body)
    end
  end
  