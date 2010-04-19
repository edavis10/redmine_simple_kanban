require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Hooks::ViewIssuesShowDetailsBottomTest < ActionController::TestCase
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
    call_hook :view_issues_show_details_bottom, args
  end

  context "#view_issues_show_details_bottom" do
    should "return a table row for the blocked field" do
      @response.body = hook

      assert_select 'tr' do
        assert_select 'th.kanban-blocked', :text => 'Blocked'
        assert_select 'td.kanban-blocked', :text => 'No'
      end
    end
  end
end
