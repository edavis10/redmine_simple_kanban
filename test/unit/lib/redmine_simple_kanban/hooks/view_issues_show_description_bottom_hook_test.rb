require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Hooks::ViewIssuesShowDescriptionBottomTest < ActionController::TestCase
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
    call_hook :view_issues_show_description_bottom, args
  end

  context "#view_issues_show_description_bottom" do
    setup do
      @project = Project.generate!
      @issue = Issue.generate_for_project!(@project)
    end

    should "return an hr" do
      @response.body = hook(:issue => @issue)
      assert_select 'hr'
    end

    context "with no skills" do
      should "not list anything" do
        @response.body = hook(:issue => @issue)

        assert_select 'p.skill-list', :count => 0
      end
    end

    context "with skills" do
      setup do
        @issue.skill_list = 'ruby, rails'
        @issue.save!
      end

      should "return a title for the section" do
        @response.body = hook(:issue => @issue)
        assert_select 'p strong', :text => /Skills required/i
      end

      should "list all the skills" do
        @response.body = hook(:issue => @issue)

        assert_select 'p.skill-list', :text => /ruby/
        assert_select 'p.skill-list', :text => /rails/
        
      end
    end
  end
end
