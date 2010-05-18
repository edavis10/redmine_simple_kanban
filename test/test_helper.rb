# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

class Test::Unit::TestCase
  def configure_plugin
    @backlog_status ||= IssueStatus.generate!(:name => 'Backlog')
    @next_status ||= IssueStatus.generate!(:name => 'Next')
    @in_progress_status ||= IssueStatus.generate!(:name => 'In Progress')
    @acceptance_status ||= IssueStatus.generate!(:name => 'Acceptance')
    @done_status ||= IssueStatus.generate!(:name => 'Done')
    
    Setting.plugin_redmine_simple_kanban = {
      'backlog_swimlane' => {'status_id' => @backlog_status.id.to_s},
      'next_swimlane' => {'status_id' => @next_status.id.to_s},
      'in_progress_swimlane' => {'status_id' => @in_progress_status.id.to_s},
      'acceptance_swimlane' => {'status_id' => @acceptance_status.id.to_s},
      'done_swimlane' => {'status_id' => @done_status.id.to_s}
    }
  end
end
