class SimpleKanbansController < ApplicationController
  unloadable

  def show
    @next_issues = Issue.visible.all(:conditions => {:status_id => status_id_for_swimlane('next_swimlane')}, :include => [:status, :priority, :tracker, :assigned_to], :limit => 3)
    @in_progress_issues = Issue.visible.all(:conditions => {:status_id => status_id_for_swimlane('in_progress_swimlane')}, :include => [:status, :priority, :tracker, :assigned_to])
    @acceptance_issues = Issue.visible.all(:conditions => {:status_id => status_id_for_swimlane('acceptance_swimlane')}, :include => [:status, :priority, :tracker, :assigned_to])
    @done_issues = Issue.visible.all(:conditions => {:status_id => status_id_for_swimlane('done_swimlane')}, :include => [:status, :priority, :tracker, :assigned_to])
    
  end

  private

  def status_id_for_swimlane(swimlane)
    if Setting.plugin_redmine_simple_kanban &&
        Setting.plugin_redmine_simple_kanban[swimlane].present? &&
        Setting.plugin_redmine_simple_kanban[swimlane]['status_id'].present?

      Setting.plugin_redmine_simple_kanban[swimlane]['status_id']
    else
      0
    end
  end
end
