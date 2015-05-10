module UserSerializer
  include AbilitySerializer


  private

  def json_only_options
    [
      :id,
      :first_name,
      :middle_name,
      :last_name,
      :username,
      :email,
      :admin,
      :deactivated_at,
      :created_at,
      :updated_at
    ]
  end
end