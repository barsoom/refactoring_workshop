require File.expand_path('../setup.rb', __FILE__)

class ProjectsController
  def index
    #when the user is logged in as an admin - display all projects
    if current_user && current_user.has_role?(:admin)
      @projects = Project.all
    else
      if !params[:id].nil?
        # when has been sent an id within the params - display projects for a specific user
        @user = User.find(params[:id])
        @projects = @user.projects
      else
        #when the user is logged in as a regular user - display projects for current user
        if current_user && current_user.has_role?(:user) && !current_user.has_role?(:admin)
          @projects = current_user.projects
        else
          #when the user is not logged in
          @flash_msg = 'You have to login in order to see the projects!'
        end
      end
    end
  end

end
