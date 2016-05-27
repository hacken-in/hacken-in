# Hier wollen wir auch alle Models anzeigen, und nicht nur
# die, die bearbeitet werden dürfen durch den Nutzer
# Die anderen Rechte zum Bearbeiten finden sich in der
# ActiveAdminAbility Klasse
class Ability < ActiveAdminAbility
  include CanCan::Ability

  def initialize(user)
    super

    can :read, Event
    can :read, SingleEvent
    can :history, SingleEvent
    can :read, User
  end
end
