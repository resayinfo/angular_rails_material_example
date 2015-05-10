class Ability
  include CanCan::Ability

  attr_reader :user

  # each of these models must have a lib file. (e.g. post_ability.rb)
  AUTHORIZABLE_MODELS = [ :Post, :User, :Reply ]

  # each of these arrays will be initialized with `alias_action`
  ALIASED_ACTIONS     = [
    [:create, :read, :update, :destroy, to: :crud]
  ]

  def self.all_actions
    Class.new.extend(CanCan::Ability).aliased_actions.flatten(2) + [:crud, :destroy]
  end

















  #############################################################################
  # More than likely, NOTHING BELOW THIS SHOULD NOT BE MODIFIED.
  # Use the global variables and the model-specific ability files to define
  # abilities.
  #############################################################################

  # include libs like 'PostAbility'
  AUTHORIZABLE_MODELS.each do |klassname|
    include [klassname, :Ability].join.constantize
  end

  def initialize(user)
    ALIASED_ACTIONS.each {|aa| alias_action *aa}

    @user = user || User.new # guest user (not logged in)
    AUTHORIZABLE_MODELS.each {|klassname| user_abilities(klassname)}
  end


  private

  # Given a klassname, calls the appropriate method for the user's role.
  # (e.g. 'admin_post_abilities' for an admin user when called with the 'Post' class)
  def user_abilities(klassname)
    temp = [user.role_name.downcase, klassname.to_s.underscore, :abilities].join('_')
    send temp
  end
end
