require File.expand_path("../setup.rb", __FILE__)

class ProjectsController
  def index
    if params[:id]
      @projects = find_projects_for_user_id(params[:id])
    elsif current_user
      @projects = find_projects_for_current_user
    else
      @flash_msg = "You have to login in order to see the projects!"
    end
  end

  private

  def find_projects_for_user_id(user_id)
    # NOTE: @user is only assigned because it's used in tests
    @user = User.find(user_id)
    @user.projects
  end

  def find_projects_for_current_user
    if current_user.has_role?(:admin)
      Project.all
    elsif current_user.has_role?(:user)
      current_user.projects
    else
      raise "We do not know how to display projects for the user role #{current_user.role}!"
    end
  end
end
