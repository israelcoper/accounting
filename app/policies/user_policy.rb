class UserPolicy < ApplicationPolicy
  def index?
    current_account? and (current_user.admin? or current_user.accountant?) 
  end

  def new?
    current_account? and current_user.admin?
  end

  def create?
    current_account? and current_user.admin?
  end

  def edit?
    current_account? and current_user.admin?
  end

  def update?
    current_account? and current_user.admin?
  end

  def destroy?
    current_account? and current_user.admin?
  end
end
