module RedmineSimpleKanban
  module Hooks
    class ControllerIssuesEditBeforeSaveHook < Redmine::Hook::ViewListener
      # * issue
      # * params
      # * time_entry
      # * journal
      def controller_issues_edit_before_save(context={})
        params = context[:params]
        
        if params && params[:issue] && params[:issue][:kanban_blocked].present?
          context[:issue].kanban_blocked = params[:issue][:kanban_blocked]
        end
      end
    end
  end
end
