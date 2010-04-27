require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Patches::PrincipalTest < ActionController::TestCase
  subject { Principal.new }

  context "Principal" do
    context "tagging" do
      should_have_named_scope 'tagged_with("tag")'

      context "for skills" do
        should "add new skill tags with #skill_list" do
          @principal = Principal.generate!
          assert @principal.skill_list.empty?

          @principal.skill_list = ["ruby", "mysql", "rails", "ruby"]
          assert @principal.save
          @principal.reload

          assert @principal.skill_list.include?("ruby"), "Missing skill"
          assert @principal.skill_list.include?("mysql"), "Missing skill"
          assert @principal.skill_list.include?("rails"), "Missing skill"
          assert_equal 3, @principal.skill_list.size, "Duplicated skills"
        end
      end
    end
  end

end
