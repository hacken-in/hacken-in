class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin
      can :manage, :all
    end

    can [:create], :comment if !user.new_record?
    can [:update, :destroy], Comment, :user_id => user.id

    can :read, :all
  end
end
