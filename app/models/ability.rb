class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present? && user.admin?
      can :manage, :all
    end

    if user.present?
      can [:create, :update, :destroy], Comment, user_id: user.id
    end

    can :read, Event
    can :read, SingleEvent
    can :history, SingleEvent
    can :read, User
    can :read, Comment
  end
end
