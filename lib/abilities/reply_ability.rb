module ReplyAbility
  private

  def admin_reply_abilities
    can_read_active_replies
    can :crud, Reply
  end

  def normal_reply_abilities
    can_read_active_replies
    can :crud, Reply, user_id: user.id, deleted_at: nil
  end

  def new_reply_abilities
    can_read_active_replies
  end

  def can_read_active_replies
    can :read, Reply, deleted_at: nil
  end
end