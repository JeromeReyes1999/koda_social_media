class PostsController < ApplicationController
    before_action :authenticate_user!, except: :index
    before_action :set_post, except: [:index, :create, :new]
    before_action :set_geo_location, only: [:new, :create]
    after_action :verify_authorized, except: [:index, :new, :create]

    def index
      @posts = (current_user.posts).or(Post.everyone).or(Post.where(user: current_user.friends).friends_only).order(id: :desc) if current_user
      @posts = Post.everyone.order(id: :desc) unless current_user
    end

    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)
      if params[:share_geo_location ] == 'true'
        @post.city = @client_location['city']
        @post.district = @client_location['district']
        @post.province = @client_location['state_prov']
      end
      @post.user = current_user
      @post.group = @group
      if @post.save
        flash[:notice] = "Successfully created!"
        redirect_to default_posts_path
      else
        render :new
      end
    end

    def edit
      authorize @post, :edit?, policy_class: PostPolicy
      @display_address = @post.location
    end

    def update
      authorize @post, :update?, policy_class: PostPolicy
      if params[:share_geo_location ].blank?
        @post.city = nil
        @post.district = nil
        @post.province = nil
      end
      if @post.update(post_params)
        flash[:notice] = "Successfully updated!"
        redirect_to default_posts_path
      else
        render :edit
      end
    end

    def destroy
      authorize @post, :destroy?, policy_class: PostPolicy
      if @post.destroy
        flash[:notice] = "Successfully deleted!"
      else
        flash[:alert] = @post.errors.full_messages.join(', ')
      end
      redirect_to default_posts_path
    end

    private

    def post_params
      params.require(:post).permit(:image, :text, :audience)
    end

    def set_geo_location
      @geo_location = IpGeoLocationService.new
      begin
        @client_location = @geo_location.get_location(get_client_ip)
        @display_address = [@client_location['state_prov'], @client_location['district'], @client_location['city']].reject(&:blank?).join(", ")
      rescue
        flash[:alert] = 'something went wrong, we cannot get your current location, you can still make a post without it'
      end
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def default_posts_path
      posts_path
    end
end
