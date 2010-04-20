require File.dirname(__FILE__) + '/../../../../test_helper'

class RedmineSimpleKanban::Patches::IssueTest < ActionController::TestCase
  subject { Issue.new }
  
  context "Issue" do
    should_have_named_scope :order_for_simple_kanban, :order => "issues.start_date ASC"
    should_have_named_scope :order_for_simple_kanban_next, :order => "issues.expedite DESC, issues.due_date ASC, issues.start_date ASC"
    should_have_named_scope :updated_today, :conditions => ["issues.updated_on > ?", Date.today.beginning_of_day]
    should_have_named_scope :includes_for_simple_kanban, :include => [:status, :priority, :tracker, :assigned_to]
    should_have_named_scope 'with_status_id(1)', :conditions => {:status_id => 1}
  end
end
