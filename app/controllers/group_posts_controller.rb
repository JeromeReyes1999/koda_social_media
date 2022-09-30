class GroupPostsController < PostsController
  before_action :set_group

  def create
    post_params[:group_id] = @group.id
    super
  end

  def publish
    authorize @post, :publish?, policy_class: GroupPostPolicy
    if @post.may_publish? @post.publish!
      flash[:notice] = 'Successfully accepted'
    else
      flash[:alert] = @post.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || group_home_path(@group)
  end

  def show_remove
    authorize @post, :show_remove?, policy_class: GroupPostPolicy
  end

  def remove
    authorize @post, :remove?, policy_class: GroupPostPolicy
    if @post.may_remove? @post.remove!
      flash[:notice] = 'Successfully accepted'
    else
      flash[:alert] = @post.errors.full_messages.join(', ')
    end
    redirect_to group_home_path(@group)
  end

  def reject
    authorize @post, :reject?, policy_class: GroupPostPolicy
    if @post.may_reject? @post.reject!
      flash[:notice] = 'Successfully rejected'
    else
      flash[:alert] = @post.errors.full_messages.join(', ')
    end
    redirect_to group_post_management_path(management: 'Pending Posts')
  end

  private

  def set_post
    @post = Post.find(params[:id] || params[:post_id])
  end

  def set_group
    @group = Group.find(params[:group_id])
    authorize @group, :member?, policy_class: GroupPostPolicy
  end

  def default_posts_path
    group_home_path(@group)
  end
end
