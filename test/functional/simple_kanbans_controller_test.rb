require File.dirname(__FILE__) + '/../test_helper'

class SimpleKanbansControllerTest < ActionController::TestCase
  context "GET :show" do
    setup do
      configure_plugin
      @project_1 = Project.generate!
      @project_2 = Project.generate!
      
      @next_1 = Issue.generate_for_project!(@project_1, :status => @next_status)
      @next_2 = Issue.generate_for_project!(@project_2, :status => @next_status)
      @next_issues = [@next_1, @next_2]

      @progress_1 = Issue.generate_for_project!(@project_1, :status => @in_progress_status)
      @progress_2 = Issue.generate_for_project!(@project_2, :status => @in_progress_status)
      @in_progress_issues = [@progress_1, @progress_2]

      @acceptance_1 = Issue.generate_for_project!(@project_1, :status => @acceptance_status)
      @acceptance_2 = Issue.generate_for_project!(@project_2, :status => @acceptance_status)
      @acceptance_issues = [@acceptance_1, @acceptance_2]

      @done_1 = Issue.generate_for_project!(@project_1, :status => @done_status)
      @done_2 = Issue.generate_for_project!(@project_2, :status => @done_status)
      @done_issues = [@done_1, @done_2]

      @user = User.generate_with_protected!
      @request.session[:user_id] = @user.id
      @role = Role.generate!(:permissions => [:view_issues])
      @member = Member.generate!(:principal => @user, :project => @project_1, :roles => [@role])
      @member = Member.generate!(:principal => @user, :project => @project_2, :roles => [@role])

      get :show
    end

    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash

    should_assign_to(:next_issues) {@next_issues}
    should_assign_to(:in_progress_issues) {@in_progress_issues}
    should_assign_to(:acceptance_issues) {@acceptance_issues}
    should_assign_to(:done_issues) {@done_issues}
  end
end
