module PostAbility
  private

  def admin_post_abilities
    can_read_active_posts
    can :crud, Post
  end

  def normal_post_abilities
    can_read_active_posts
    can :crud, Post, user_id: user.id, deleted_at: nil
  end

  def new_post_abilities
    can_read_active_posts
    can :new, Post
  end

  def can_read_active_posts
    can :read, Post, deleted_at: nil
  end
end