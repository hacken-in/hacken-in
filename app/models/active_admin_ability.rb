# Im ActiveAdmin wollen wir nur
# sachen anzeigen, die der Nutzer auch wirklich
# bearbeiten kann, sonst verwirrt das zu viel.
#
# Deswegen sind alle Bearbeiten-Regeln hier. Und die
# restlichen in der "normalen" Ability Klasse
class ActiveAdminAbility
  include CanCan::Ability

  def initialize(user)
    if user.present? && user.admin?
      can :manage, :all
    elsif user.present?
      # Achtung! Keine Blocks benutzen, sondern immer die
      # Hash Syntax. Nur so kann CanCan SQL-Queries draus basteln

      # Alle eigenen Kommetare bearbeiten dürfen
      can [:create, :update, :destroy], Comment, user_id: user.id

      # Alle Regionen, die einem zugewiesen wurden
      if user.region_organizers.present?
        can :create, Event
        can :create, SingleEvent
        can :create, Venue
        can :manage, Event, region_id: user.region_organizers.pluck(:region_id)
        can :manage, SingleEvent, event: {region_id: user.region_organizers.pluck(:region_id)}
        can :manage, Venue, region_id: user.region_organizers.pluck(:region_id)

        can :create, RadarSetting
        can :manage, RadarSetting, event: {region_id: user.region_organizers.pluck(:region_id)}
        can :manage, RadarEntry, event: {region_id: user.region_organizers.pluck(:region_id)}
      end

      if user.event_curations.present?
        can :manage, Event, id: user.event_curations.pluck(:event_id)
        can :manage, SingleEvent, event_id: user.event_curations.pluck(:event_id)

        can :create, RadarSetting
        can :manage, RadarSetting, event_id: user.event_curations.pluck(:event_id)
        can :manage, RadarEntry, event: { id: user.event_curations.pluck(:event_id) }
      end

      # Wenn man Events hat, darf man auch das Dashboard anzeigen und somit
      # in den Admin-Bereich
      if user.region_organizers.length > 0 || user.event_curations.length > 0
        can :read, ActiveAdmin::Page, :name => "Dashboard"
        can [:manage], Suggestion
      end
    end
  end
end
