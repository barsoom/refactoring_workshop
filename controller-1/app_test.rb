#!/usr/bin/env ruby -w
gem "minitest"
require 'minitest/autorun'
require_relative "app"

class TestProjectsController < Minitest::Test
  def setup
    @controller = ProjectsController.new
  end

  def test_index_when_current_user_is_an_admin
    @current_user = User.new("walter@savewalterwhite.com", "admin")
    @controller.current_user = @current_user
    @controller.index
    assert_equal Project.all, @controller.projects
  end

  def test_index_when_current_user_is_not_an_admin
    @controller.params = {id: nil }
    @current_user = User.new("walter@savewalterwhite.com", "user")
    @controller.current_user = @current_user
    @controller.index
    assert_equal @current_user.projects, @controller.projects
  end

  def test_index_when_no_current_user
    @controller.params = {id: nil }
    @controller.current_user = nil
    @controller.index
    assert_equal "You have to login in order to see the projects!", @controller.flash_msg
  end

  def test_index_when_params_id_is_sent
    @controller.params = {id: 1 }
    @controller.current_user = nil
    @controller.index
    assert_equal @controller.user.projects, @controller.projects
  end
end
