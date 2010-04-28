require 'test_helper'

class SimpleKanbanTest < ActiveSupport::TestCase
  context "SimpleKanban#next_issue" do
    setup do
      configure_plugin
      User.current = @user = User.generate_with_protected!(:skill_list => ['ruby','rails','mysql'])

      @project = Project.generate!
      @role = Role.generate!(:permissions => [:view_issues])
      Member.generate!(:project => @project, :principal => @user, :roles => [@role])
      
      @dummy_issue = Issue.generate_for_project!(@project, :status => @in_progress_status)
      @blocked_issue = Issue.generate_for_project!(@project, :status => @next_status, :kanban_blocked => true)
      @in_progress_issue = Issue.generate_for_project!(@project, :status => @in_progress_status)
      @accepted_issue = Issue.generate_for_project!(@project, :status => @acceptance_status)

      @later_next_issue = Issue.generate_for_project!(@project, :subject => 'Due later', :status => @next_status, :due_date => 3.days.from_now)

      @next_issue_non_expedite = Issue.generate_for_project!(@project, :subject => 'Not Expedite', :status => @next_status, :due_date => Date.tomorrow)
      @assigned_next_issue = Issue.generate_for_project!(@project, :subject => 'Next issue', :status => @next_status, :due_date => Date.tomorrow, :expedite => true, :assigned_to => @user)

      @next_issue_with_non_matching_skill = Issue.generate_for_project!(@project, :subject => 'Next issue', :status => @next_status, :due_date => Date.tomorrow, :expedite => true, :assigned_to => nil)
      @next_issue_with_non_matching_skill.skill_list = ['ruby', 'python']
      @next_issue_with_non_matching_skill.save!
      
      @next_issue = Issue.generate_for_project!(@project, :subject => 'Next issue', :status => @next_status, :due_date => Date.tomorrow, :expedite => true, :assigned_to => nil)
      @next_issue.skill_list = ['ruby','rails']
      @next_issue.save!
    end

    should "find an issue that is visible" do
      response = SimpleKanban.next_issue
      assert response, "No issue returned"
      assert response.visible?(@user), "Issue is not visible to the user."
    end

    should "find an issue in the Next swimlane" do
      response = SimpleKanban.next_issue
      assert response, "No issue returned"
      assert_equal @next_status, response.status
    end

    should "not find an issue that is blocked" do
      response = SimpleKanban.next_issue
      assert response, "No issue returned"
      assert !response.kanban_blocked?, "Returned a blocked issue."
    end
    
    should "find the issue due soonest" do
      response = SimpleKanban.next_issue
      assert response, "No issue returned"
      assert_equal @next_issue, response
    end
    
    should "favor an expedited issue over a normal issue" do
      response = SimpleKanban.next_issue
      assert response, "No issue returned"
      assert_equal @next_issue, response
    end

    should "find an unassigned issue" do
      response = SimpleKanban.next_issue
      assert response, "No issue returned"
      assert_equal nil, response.assigned_to
    end

    should "match skill requirements to a user" do
      response = SimpleKanban.next_issue
      assert response, "No issue returned"
      assert_equal @next_issue, response
      assert_contains(response.skill_list, 'ruby')
      assert_contains(response.skill_list, 'rails')
    end
  end
end
  
