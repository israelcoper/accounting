class AccountPolicy < ApplicationPolicy
  def show?
    current_account? ? true : false
  end

  def edit?
    current_account? and current_user.admin?
  end

  def update?
    current_account? and current_user.admin?
  end
end
