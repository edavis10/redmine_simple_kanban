require File.dirname(__FILE__) + '/../test_helper'

class SimpleKanbansControllerTest < ActionController::TestCase
  context "GET :show" do
    setup do
      configure_plugin
      @project_1 = Project.generate!
      @project_2 = Project.generate!
      
      @next_1 = Issue.generate_for_project!(@project_1, :status => @next_status)
      @next_2 = Issue.generate_for_project!(@project_2, :status => @next_status)
      @next_3 = Issue.generate_for_project!(@project_2, :status => @next_status)
      @next_4 = Issue.generate_for_project!(@project_2, :status => @next_status)
      @next_issues = [@next_1, @next_2, @next_3]

      @progress_1 = Issue.generate_for_project!(@project_1, :status => @in_progress_status)
      @progress_2 = Issue.generate_for_project!(@project_2, :status => @in_progress_status)
      @in_progress_issues = [@progress_1, @progress_2]

      @acceptance_1 = Issue.generate_for_project!(@project_1, :status => @acceptance_status)
      @acceptance_2 = Issue.generate_for_project!(@project_2, :status => @acceptance_status)
      @acceptance_issues = [@acceptance_1, @acceptance_2]

      @done_1 = Issue.generate_for_project!(@project_1, :status => @done_status, :updated_on => 2.days.ago)
      @done_2 = Issue.generate_for_project!(@project_2, :status => @done_status, :updated_on => Date.today.beginning_of_day + 6.hours)
      @done_3 = Issue.generate_for_project!(@project_2, :status => @done_status, :updated_on => Date.today.beginning_of_day + 1.hour)
      @done_issues = [@done_2, @done_3]

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
    should_assign_to(:next_issue) {@next_1}

    should "show the next issue" do
      assert_select "div#next-issue", :text => /#{@next_1.subject}/
    end
  end

  context "GET :show with filter" do
    setup do
      configure_plugin
      @project_1 = Project.generate!
      @project_2 = Project.generate!
      @user = User.generate_with_protected!
      @filtered_user = User.generate_with_protected!
      @request.session[:user_id] = @user.id
      @role = Role.generate!(:permissions => [:view_issues])
      @member = Member.generate!(:principal => @user, :project => @project_1, :roles => [@role])
      @member = Member.generate!(:principal => @user, :project => @project_2, :roles => [@role])

      @next_1 = Issue.generate_for_project!(@project_1, :status => @next_status)
      @next_2 = Issue.generate_for_project!(@project_2, :status => @next_status, :assigned_to => @filtered_user)
      @next_3 = Issue.generate_for_project!(@project_2, :status => @next_status, :assigned_to => @user) # filtered

      @progress_1 = Issue.generate_for_project!(@project_1, :status => @in_progress_status, :assigned_to => @user) # filtered
      @progress_2 = Issue.generate_for_project!(@project_2, :status => @in_progress_status, :assigned_to => @filtered_user)

      @acceptance_1 = Issue.generate_for_project!(@project_1, :status => @acceptance_status, :assigned_to => @filtered_user)
      @acceptance_2 = Issue.generate_for_project!(@project_2, :status => @acceptance_status, :assigned_to => @user)

      @done_1 = Issue.generate_for_project!(@project_1, :status => @done_status, :updated_on => 2.days.ago, :assigned_to => @user)
      @done_2 = Issue.generate_for_project!(@project_2, :status => @done_status, :updated_on => Date.today.beginning_of_day + 6.hours, :assigned_to => @filtered_user)
      @done_3 = Issue.generate_for_project!(@project_2, :status => @done_status, :updated_on => Date.today.beginning_of_day + 1.hour, :assigned_to => @user)

      get :show, :filter => @filtered_user.id
    end

    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash

    should_assign_to(:next_issues) { [@next_1, @next_2] }
    should_assign_to(:in_progress_issues) { [@progress_2] }
    should_assign_to(:acceptance_issues) { [@acceptance_1] }
    should_assign_to(:done_issues) { [@done_2] }
  end

  context "GET :show with JS format" do
    setup do
      configure_plugin
      @project_1 = Project.generate!
      @project_2 = Project.generate!
      
      @user = User.generate_with_protected!
      @request.session[:user_id] = @user.id
      @role = Role.generate!(:permissions => [:view_issues])
      @member = Member.generate!(:principal => @user, :project => @project_1, :roles => [@role])
      @member = Member.generate!(:principal => @user, :project => @project_2, :roles => [@role])

      get :show, :format => 'js'
    end

    should_respond_with :success
    should_render_template :kanban_board
    should_not_set_the_flash
  end

end
