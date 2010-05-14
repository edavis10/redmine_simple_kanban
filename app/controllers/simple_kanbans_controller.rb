class SimpleKanbansController < ApplicationController
  unloadable

  def show
    if params[:filter].blank?
      # Next uses different finders
      @next_issues = Issue.visible.order_for_simple_kanban_next.includes_for_simple_kanban.with_status_id(status_id_for_swimlane('next_swimlane')).all(:limit => 3)
      @in_progress_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('in_progress_swimlane'))
      @acceptance_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('acceptance_swimlane'))
      @done_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('done_swimlane')).updated_today
      @next_issue = SimpleKanban.next_issue(User.current)
    else
      @filtered_user = User.find(params[:filter])
      # Next uses different finders
      @next_issues = Issue.visible.order_for_simple_kanban_next.includes_for_simple_kanban.with_status_id(status_id_for_swimlane('next_swimlane')).assigned_to(params[:filter]).all(:limit => 3)
      @in_progress_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('in_progress_swimlane')).assigned_to(params[:filter])
      @acceptance_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('acceptance_swimlane')).assigned_to(params[:filter])
      @done_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('done_swimlane')).updated_today.assigned_to(params[:filter])
      @next_issue = SimpleKanban.next_issue(@filtered_user)
    end
    

    respond_to do |format|
      format.html {}
      format.js { render :partial => 'dashboard', :layout => false }
    end
  end

  def take_issue
    @issue = Issue.visible.find_by_id(params[:issue_id])

    respond_to do |format|
      if @issue && @issue.update_attribute(:assigned_to_id, User.current.id)
        format.html {
          flash[:notice] = l(:simple_kanban_label_issue_taken)
          redirect_to simple_kanban_url
        }
      else
        format.html {
          flash[:error] = l(:simple_kanban_label_issue_can_not_be_taken)
          redirect_to simple_kanban_url
        }

      end
    end
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
