require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Hooks::ViewIssuesFormDetailsBottomTest < ActionController::TestCase
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
    call_hook :view_issues_form_details_bottom, args
  end

  context "#view_issues_form_details_bottom" do
    # Mock
    should "render the kanban_blocked partial" do
      project = Project.generate!
      issue = Issue.generate_for_project!(project)
      controller
      @controller.expects(:render_to_string).returns('')
                                                  
      @response.body = hook :issue => issue
    end
  end
end
