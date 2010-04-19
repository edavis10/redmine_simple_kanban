module RedmineSimpleKanban
  module Hooks
    class ViewIssuesFormDetailsBottomHook < Redmine::Hook::ViewListener
      render_on :view_issues_form_details_bottom, :partial => 'issues/kanban_blocked'
    end
  end
end
