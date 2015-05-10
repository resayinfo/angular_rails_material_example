class Api::V1::PostsController < Api::V1::ApiController
  skip_before_filter :ensure_authenticated, only: [:new, :index, :show]
  load_and_authorize_resource except: :index


  # GET /posts
  # GET /posts.json
  def index
    authorize! :index, Post
    @posts = PostsQueryFilter.new(params, current_ability).run_query
  end

  # GET /posts/new
  def new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end


  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    if @post.save
      render json: {post: @post}, status: :created
    else
      render json: {errors: @post.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1.json
  def update
    if @post.update_attributes(post_params)
      render json: {post: @post}, status: :no_content
    else
      render json: {errors: @post.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.soft_delete!
    head :no_content
  end


  private

  def post_params
    return nil if params[:post].blank?
    params.require(:post).permit(
      :id,
      :title,
      :body,
      :user_id,
      :league_type,
      :created_at,
      :updated_at,
      { league_attributes: all_league_attributes }
    )
  end

  def all_league_attributes
    @all_league_attributes ||= LeagueLike::ALL_LEAGUE_CLASSES.map do |t|
      t.column_names.map(&:to_sym)
    end.flatten.uniq
  end
end