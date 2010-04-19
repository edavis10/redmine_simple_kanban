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
      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project)
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
  end
end
