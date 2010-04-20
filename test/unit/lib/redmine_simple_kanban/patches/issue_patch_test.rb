require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Patches::IssueTest < ActionController::TestCase
  subject { Issue.new }
  
  context "Issue" do
    should_have_named_scope :order_for_simple_kanban, :order => "issues.start_date ASC"
    should_have_named_scope :order_for_simple_kanban_next, :order => "issues.expedite DESC, issues.due_date ASC, issues.start_date ASC"
  end
end
