class Api::V1::RepliesController < Api::V1::ApiController
  load_and_authorize_resource except: :index

  # GET /replies
  # GET /replies.json
  def index
    authorize! :index, Post
    @replies = RepliesQueryFilter.new(params, current_ability).run_query
  end

  # GET /replies/new
  def new
  end

  # GET /replies/1
  # GET /replies/1.json
  def show
  end


  # GET /replies/1/edit
  def edit
  end

  # POST /replies
  def create
    if @reply.save
      render json: {reply: @reply}, status: :created
    else
      render json: {errors: @reply.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /replies/1.json
  def update
    if @reply.update_attributes(reply_params)
      render json: {reply: @reply}, status: :no_content
    else
      render json: {errors: @reply.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /replies/1
  def destroy
    @reply.soft_delete!
    head :no_content
  end


  private

  def reply_params
    return nil if params[:reply].blank?
    params.require(:reply).permit(
      :id,
      :body,
      :user_id,
      :post_id
    )
  end
end