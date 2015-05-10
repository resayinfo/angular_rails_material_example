module PostSerializer
  include AbilitySerializer


  private

  def json_include_options
    [:league]
  end

  def json_only_options
    [
      :id,
      :user_id,
      :title,
      :body,
      :league_type,
      :deleted_at,
      :created_at,
      :updated_at
    ]
  end
end