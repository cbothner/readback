# frozen_string_literal: true

class PostsController < ApplicationController
  def show
    set_post
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params

    if @post.save
      redirect_to post_path(@post), successfully_created
    else
      render :new
    end
  end

  def edit
    set_post
  end

  def update
    set_post

    if @post.update post_params
      redirect_to post_path(@post), successfully_updated
    else
      render :edit
    end
  end

  private

  def set_post
    @post = Post.find params[:id]
  end

  def post_params
    params.require(:post).permit(:title, :author, :content, images: [])
  end
end
