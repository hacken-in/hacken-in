class Ability
  include CanCan::Ability

  def initialize(user)
    if !user.nil? && user.admin
      can :manage, :all
    end

    can :read, Event
    can :read, SingleEvent
    can :read, User

    can :create, Comment if !user.nil?
    can [:edit, :update, :destroy], Comment, :user_id => user.id if !user.nil?
  end
end
