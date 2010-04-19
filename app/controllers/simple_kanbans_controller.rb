class SimpleKanbansController < ApplicationController
  unloadable

  def show
    @next_issues = Issue.visible.all(:conditions => {:status_id => status_id_for_swimlane('next_swimlane')})
    @in_progress_issues = Issue.visible.all(:conditions => {:status_id => status_id_for_swimlane('in_progress_swimlane')})
    @acceptance_issues = Issue.visible.all(:conditions => {:status_id => status_id_for_swimlane('acceptance_swimlane')})
    @done_issues = Issue.visible.all(:conditions => {:status_id => status_id_for_swimlane('done_swimlane')})
    
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
