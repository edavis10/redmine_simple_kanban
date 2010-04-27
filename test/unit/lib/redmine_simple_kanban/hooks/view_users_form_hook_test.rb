require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Hooks::ViewUsersFormTest < ActionController::TestCase
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
    call_hook :view_users_form, args
  end

  context "#view_users_form" do
    # Mock
    should "render the user skills partial" do
      user = User.generate_with_protected!
      controller
      @controller.expects(:render_to_string).returns('')
                                                  
      @response.body = hook :user => user
    end
  end
end
