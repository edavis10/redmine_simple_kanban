require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Hooks::ControllerIssuesEditBeforeSaveTest < ActionController::TestCase
  include Redmine::Hook::Helper

  def controller
    @controller ||= ApplicationController.new
    @controller.response ||= ActionController::TestResponse.new
    @controller
  end

  def request
    @request ||= ActionController::TestRequest.new
  end
  
  def hook(args={})
    call_hook :controller_issues_edit_before_save, args
  end

  context "#controller_issues_edit_before_save" do
    setup do
      @user = User.generate!
      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project)
      @issue.init_journal(@user)
    end

    context "without a kanban_blocked parameter" do
      should "do nothing to the issue" do
        pre = @issue.kanban_blocked
        hook(:issue => @issue, :params => {})
        post = @issue.reload.kanban_blocked

        assert_equal pre, post, "field changed"
      end
    end

    context "with a kanban_blocked parameter" do
      should "set the issue's value" do
        pre = @issue.kanban_blocked
        hook(:issue => @issue, :params => { :issue => {:kanban_blocked => '1'}})
        post = @issue.kanban_blocked

        assert_not_equal pre, post, "field did not change"

      end
    end

    context "without a expedite parameter" do
      should "do nothing to the issue" do
        pre = @issue.expedite
        hook(:issue => @issue, :params => {})
        post = @issue.reload.expedite

        assert_equal pre, post, "field changed"
      end
    end

    context "with a expedite parameter" do
      should "set the issue's value" do
        pre = @issue.expedite
        hook(:issue => @issue, :params => { :issue => {:expedite => '1'}})
        post = @issue.expedite

        assert_not_equal pre, post, "field did not change"

      end
    end

    context "without a skill list parameter" do
      should "do nothing to the issue" do
        pre = @issue.skill_list
        hook(:issue => @issue, :params => {})
        post = @issue.reload.skill_list

        assert_equal pre, post, "field changed"
      end
    end

    context "with a skill list parameter" do
      should "set the issue's value" do
        pre = @issue.skill_list
        hook(:issue => @issue, :params => { :issue => {:skill_list => 'ruby,rails,'}})
        post = @issue.skill_list

        assert_not_equal pre, post, "field did not change"

      end

      should "log the change to the issue's journals" do
        hook(:issue => @issue, :params => { :issue => {:skill_list => 'ruby,rails'}})

        assert @issue.save
        @issue.reload
        
        last_journal = @issue.journals.last
        assert last_journal
        assert_equal 1, last_journal.details.size
        last_journal_details = last_journal.details.first
        assert_equal 'skill_list', last_journal_details.prop_key
        assert_equal 'ruby,rails', last_journal_details.value
        assert_equal '', last_journal_details.old_value
        
      end
    end
  end
end
