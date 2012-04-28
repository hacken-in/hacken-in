class Ability
  include CanCan::Ability

  def initialize(user)
    if !user.nil? && user.admin
      can :manage, :all
    end

    if !user.nil?
      can [:create, :edit, :update], Event
      can [:create, :edit, :update], SingleEvent
      can [:edit, :update, :destroy], Comment, user_id: user.id
      can :create, Comment
    end

    can :read, Event
    can :read, SingleEvent
    can :read, User
  end
end
