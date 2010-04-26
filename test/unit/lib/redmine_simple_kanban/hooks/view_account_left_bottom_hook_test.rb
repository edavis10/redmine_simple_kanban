require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Hooks::ViewAccountLeftBottomTest < ActionController::TestCase
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
    call_hook :view_account_left_bottom, args
  end

  context "#view_account_left_bottom" do
    setup do
      @user = User.generate_with_protected!
    end
    
    context "for a user without any skills" do
      should "return an empty string" do
        @response.body = hook :user => @user
        assert @response.body.blank?
      end
      
    end

    context "for a user with skills" do
      setup do
        @user.skill_list = ["ruby", "rails", "debian"]
        @user.save!
      end

      should "show a skills heading" do
        @response.body = hook :user => @user
        assert_select "h3", :text => /Skills/
      end
      
      should "list the skills a user has" do
        @response.body = hook :user => @user
        assert_select "ul.skills" do
          assert_select "li", :text => 'ruby'
          assert_select "li", :text => 'rails'
          assert_select "li", :text => 'debian'
        end
      end
    end
  end
end
