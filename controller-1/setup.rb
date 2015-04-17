require "attr_extras"

class User
  rattr_initialize :email, :role

  def self.find(id)
    case id
    when 666
      new("admin@test.com", "admin")
    else
      new("developer@test.com", "developer")
    end
  end

  def self.find_regular_user(id)
    user = find(id)
    raise "Admin, fool!" if user.has_role?(:admin)
    user
  end

  def projects
    [ :private_project ]
  end

  def has_role?(role)
    self.role == role.to_s
  end

  def accessible_projects
    if has_role?(:admin)
      Project.all
    else
      projects
    end
  end
end

class Project
  def self.all
    [ :public_project, :private_project ]
  end
end

class ProjectsController
  attr_accessor :current_user, :flash_msg, :projects, :params, :user
end
