require File.expand_path("../setup.rb", __FILE__)

class ProjectsController
  def index
    @user = find_user

    if user
      @projects = user.accessible_projects
    else
      @flash_msg = "You have to log in in order to see the projects!"
    end
  end

  private

  def find_user
    if admin?
      current_user
    elsif params[:id]
      User.find(params[:id])
      #User.find_regular_user(params[:id])
    elsif regular_user?
      current_user
    else
      nil
    end
  end

  def admin?
    current_user && current_user.has_role?(:admin)
  end

  def regular_user?
    current_user && current_user.has_role?(:user)
  end
end
