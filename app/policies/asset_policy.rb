class AssetPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all.where(user_id: user)
    end
  end

  def index?
    true
  end
end
