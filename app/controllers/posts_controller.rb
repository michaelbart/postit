class PostsController < ApplicationController
  # before_action is used for:
  # 1. setting up an instance variable for action:
  before_action :set_post, only: [:show, :edit, :update, :vote]
  # 2. redirecting based on some condition:
  before_action :require_user, except: [:index, :show]

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user
    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path
    else # validation error
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "The post was updated"
      redirect_to posts_path
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, voter: current_user, vote: params[:vote])
    if @vote.valid?
      flash[:notice] = "Your vote was counted."
    else
      flash[:error] = "You have already voted for that post."
    end
    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:title,:url,:description, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
