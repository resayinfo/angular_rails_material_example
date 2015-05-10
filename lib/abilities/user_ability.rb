module UserAbility
  private

  def admin_user_abilities
    can :crud, User
  end

  def normal_user_abilities
    can_read_active_users
    can :update, User, id: user.id, deactivated_at: nil
  end

  def new_user_abilities
    can_read_active_users
    can :create, User
  end

  def can_read_active_users
    can :read, User, deactivated_at: nil
  end
end