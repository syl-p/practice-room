# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:get_versions_list, :index, :search], Exercise
    can :read, Exercise, {published: true}
    can :read, Comment
    can :read, User
    can [:read, :get_by_slug], Category

    # Abilities for logged users
    if user.id
      can :manage, Exercise, {user_id: user.id}
      can :add_to_favorites, Exercise
      can :remove_from_favorites, Exercise
      can :add_to_practice, Exercise
      can :remove_from_practice, Exercise

      can :manage, Comment, {user_id: user.id}
      can :manage, User, {id: user.id}
      can :delete_avatar, User, {id: user.id}

      can :manage, Friendship, {requestor_id: user.id}
      can :manage, Friendship, {receiver_id: user.id}

      # can :update, Version, :published, {exercise: {user_id: user.id}}

      # Abilities for admins
      if user.role == "admin"
        can :manage, :all
      end

      # Abilities for moderators
      if user.role == "moderator"
        can :manage, Exercise
        can :manage, Comment
        # can :manage, User
        can :manage, Category
      end
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
