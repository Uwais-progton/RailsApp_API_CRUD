# app/controllers/posts_controller.rb

class PostsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create ,:destroy ,:update]
    before_action :set_post, only: [:show, :update, :destroy]
  
    def index
      @posts = JSON.parse(RestClient.get('https://jsonplaceholder.typicode.com/posts'))
      render json: @posts
    end
  
    def show
      render json: @post
    end
  
    def create
      @post = Post.new(post_params)
      if @post.save
        render json: @post, status: :created, location: @post
      else
        render json: {errors: @post.errors.full_messages}, status: :unprocessable_entity
      end
    end
  
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
    end
  
    def post_params
      params.require(:post).permit(:title, :body)
    end
  end
  