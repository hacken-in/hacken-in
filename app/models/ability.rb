class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.email == "bodo@wannawork.de"
      can :manage, :all
    end
  end
end
