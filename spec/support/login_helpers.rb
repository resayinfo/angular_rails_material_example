module LoginHelpers
  def stub_login(user=nil)
    user ||= User.new
    allow(controller).to receive(:signed_in?){ true }
    allow(controller).to receive(:current_user){ user }
    user
  end

  def stub_cancan(subject)
    ability = Object.new
    ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability){ ability }
    ability.can :manage, subject
  end

  def stub_auth(opts={})
    stub_login opts[:user]
    stub_cancan opts[:subject]
  end
end