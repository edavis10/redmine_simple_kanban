require File.dirname(__FILE__) + '/../test_helper'

class SimpleKanbansControllerTest < ActionController::TestCase
  context "GET :show" do
    setup do
      configure_plugin
      @project_1 = Project.generate!
      @project_2 = Project.generate!

      @backlog_1 = Issue.generate_for_project!(@project_1, :status => @backlog_status)
      @backlog_2 = Issue.generate_for_project!(@project_1, :status => @backlog_status)
      @backlog_3 = Issue.generate_for_project!(@project_2, :status => @backlog_status)
      @backlog_issues = [@backlog_1, @backlog_2, @backlog_3]
      
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

    should_assign_to(:backlog_issues) {@backlog_issues}
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
      Member.generate!(:principal => @filtered_user, :project => @project_2, :roles => [@role])

      @backlog_1 = Issue.generate_for_project!(@project_1, :status => @backlog_status)
      @backlog_2 = Issue.generate_for_project!(@project_1, :status => @backlog_status, :assigned_to => @user)
      @backlog_3 = Issue.generate_for_project!(@project_2, :status => @backlog_status, :assigned_to => @filtered_user)
      
      @next_1 = Issue.generate_for_project!(@project_1, :status => @next_status)
      @next_2 = Issue.generate_for_project!(@project_2, :status => @next_status, :assigned_to => @filtered_user)
      @next_3 = Issue.generate_for_project!(@project_2, :status => @next_status, :assigned_to => @user) # filtered
      @next_4 = Issue.generate_for_project!(@project_2, :status => @next_status)
      
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

    should_assign_to(:backlog_issues) { [@backlog_1, @backlog_3] }
    should_assign_to(:next_issues) { [@next_1, @next_2, @next_4] }
    should_assign_to(:in_progress_issues) { [@progress_2] }
    should_assign_to(:acceptance_issues) { [@acceptance_1] }
    should_assign_to(:done_issues) { [@done_2] }

    should "show the next issue for the filtered user" do
      assert_select "div#next-issue", :text => /#{@next_4.subject}/
    end

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
    should_render_template :dashboard
    should_not_set_the_flash
  end

  context "PUT :take_issue" do
    setup do
      configure_plugin
      @project_1 = Project.generate!
      @issue = Issue.generate_for_project!(@project_1, :assigned_to => nil)
      
      @user = User.generate_with_protected!
      @request.session[:user_id] = @user.id

    end

    context "for an issue the user can update" do
      setup do
        @role = Role.generate!(:permissions => [:view_issues])
        @member = Member.generate!(:principal => @user, :project => @project_1, :roles => [@role])

        put :take_issue, :issue_id => @issue.id
      end

      should_respond_with :redirect
      should_redirect_to("kanban board") { simple_kanban_url }
      should_set_the_flash_to /taken/i

      should "assign the issue to the current user" do
        @issue.reload
        assert_equal @user, @issue.assigned_to
      end
    end

    context "for an issue the user can't update" do
      setup do
        put :take_issue, :issue_id => @issue.id
      end

      should_respond_with :redirect
      should_redirect_to("kanban board") { simple_kanban_url }
      should_set_the_flash_to /could not be taken/i

      should "not assign the issue to the current user" do
        @issue.reload
        assert_equal nil, @issue.assigned_to
      end
    end

  end

  context "POST :new_issue" do
    setup do
      configure_plugin
      IssuePriority.generate!(:is_default => true)
      IssueStatus.generate!(:is_default => true)
      @user = User.generate_with_protected!
      @request.session[:user_id] = @user.id
    end

    context "with successful save" do
      setup do
        @count = Issue.count
        post :new_issue, :issue => {
          :subject => "Required",
          :due_date => '2010-12-31',
          :description => 'A description'
        }
      end
      
      should_respond_with :redirect
      should_redirect_to("kanban board") { simple_kanban_url }
      should_set_the_flash_to /success/i

      context "new issue" do
        setup do
          @issue = Issue.last
        end
        
        should "be saved" do
          assert_equal @count +1, Issue.count, "Issue was not saved"
        end

        should "take the subject from the params" do
          assert_equal "Required", @issue.subject
        end
        
        should "take the description from the params" do
          assert_equal "A description", @issue.description
        end
        
        should "take the due date from the params" do
          assert_equal "2010-12-31", @issue.due_date.to_s
        end
        
        should "take the project from the plugin settings" do
          assert_equal @target_project, @issue.project
        end
        
        should "take the tracker from the first tracker on the project" do
          assert_equal @target_project.trackers.first, @issue.tracker
        end
        
      end
    end

    context "with an unsuccessful save" do
      setup do
        @count = Issue.count
        post :new_issue, :issue => {:description => 'missing subject'}
      end
      
      should_respond_with :success
      should_render_template 'show'
      should_set_the_flash_to /failed/i

      context "new issue" do
        should "not be saved" do
          assert_equal @count, Issue.count, "Issue was saved"
        end
        
        # TODO: must be a better test
        should "display the dialog right away" do
          assert_select 'head script', :text => /failed_creation = true/i
        end
        
        should "fill in the issue form from the params" do
          assert_select '#issue_description', :text => /missing subject/i
        end
      end
      
    end

  end

end
