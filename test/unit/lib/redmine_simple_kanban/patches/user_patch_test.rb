require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Patches::UserTest < ActionController::TestCase
  subject { User.new }

  context "User" do
    context "tagging" do
      should_have_named_scope 'tagged_with("tag")'

      context "for skills" do
        should "add new skill tags with #skill_list" do
          @user = User.generate_with_protected!
          assert @user.skill_list.empty?

          @user.skill_list = ["ruby", "mysql", "rails", "ruby"]
          assert @user.save
          @user.reload

          assert @user.skill_list.include?("ruby"), "Missing skill"
          assert @user.skill_list.include?("mysql"), "Missing skill"
          assert @user.skill_list.include?("rails"), "Missing skill"
          assert_equal 3, @user.skill_list.size, "Duplicated skills"
        end
      end
    end
  end

end
