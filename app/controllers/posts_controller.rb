class PostsController < ApplicationController
    before_action :authenticate_user!, except: :index
    before_action :set_post, except: [:index, :new, :create]

    def index
      @posts= Post.all
    end

    def new
      @post = Post.new
    end

    def edit; end

    def update
      if @post.update(post_params)
        flash[:notice] = "Successfully updated!"
        redirect_to posts_path
      else
        render :edit
      end
    end

    def destroy
      if @post.destroy
        flash[:notice] = "Successfully deleted!"
      else
        flash[:alert] = @post.errors.full_messages.join(', ')
      end
      redirect_to posts_path
    end

    def create
      @post = Post.new(post_params)
      @post.user = current_user
      if @post.save
        flash[:notice] = "Successfully created!"
        redirect_to posts_path
      else
        render :new
      end
    end

    private

    def post_params
      params.require(:post).permit(:image, :text, :location)
    end

    def set_post
      @post = Post.find(params[:id])
    end
end
