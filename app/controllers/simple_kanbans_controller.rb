class SimpleKanbansController < ApplicationController
  unloadable
  before_filter :authorize_global

  def show
    if params[:filter].blank?
      # Next uses different finders
      @next_issues = Issue.visible.order_for_simple_kanban_next.includes_for_simple_kanban.with_status_id(status_id_for_swimlane('next_swimlane')).all
      @backlog_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('backlog_swimlane'))
      @in_progress_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('in_progress_swimlane'))
      @acceptance_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('acceptance_swimlane'))
      @done_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('done_swimlane')).updated_today
      @next_issue = SimpleKanban.next_issue(User.current)
    else
      @filtered_user = User.find(params[:filter])
      # Next uses different finders
      @next_issues = Issue.visible.order_for_simple_kanban_next.includes_for_simple_kanban.with_status_id(status_id_for_swimlane('next_swimlane')).assigned_to(params[:filter]).all
      @backlog_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('backlog_swimlane')).assigned_to(params[:filter])
      @in_progress_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('in_progress_swimlane')).assigned_to(params[:filter])
      @acceptance_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('acceptance_swimlane')).assigned_to(params[:filter])
      @done_issues = Issue.for_simple_kanban_swimlane(status_id_for_swimlane('done_swimlane')).updated_today.assigned_to(params[:filter])
      @next_issue = SimpleKanban.next_issue(@filtered_user)
    end

    @backlog_issues = @backlog_issues.group_by(&:project)
    @next_issues = @next_issues.group_by(&:project)
    @in_progress_issues = @in_progress_issues.group_by(&:project)
    @acceptance_issues = @acceptance_issues.group_by(&:project)
    @done_issues = @done_issues.group_by(&:project)

    @issue ||= Issue.new
    
    respond_to do |format|
      format.html {}
      format.js { render :partial => 'dashboard', :layout => false, :locals => {:next_issue => @next_issue} }
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
          flash.now[:error] = l(:simple_kanban_label_issue_can_not_be_taken)
          redirect_to simple_kanban_url
        }

      end
    end
  end

  def new_issue
    @issue = Issue.new(params[:issue]) do |issue|
      issue.author = User.current
      project = Project.find(target_project)
      issue.project = project
      issue.tracker = project.trackers.first if project.trackers.present?
    end

    respond_to do |format|
      if @issue.save
        format.html {
          flash[:notice] = l(:notice_successful_create)
          redirect_to simple_kanban_url
        }
      else
        format.html {
          flash[:error] = l(:simple_kanban_error_failed_to_create)
          show
          render :action => 'show'
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

  def target_project
    if Setting.plugin_redmine_simple_kanban && Setting.plugin_redmine_simple_kanban['target_project'].present?
      Setting.plugin_redmine_simple_kanban['target_project']
    else
      nil
    end
  end
end
