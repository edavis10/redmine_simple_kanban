module RedmineSimpleKanban
  module Hooks
    class ViewIssuesShowDetailsBottomHook < Redmine::Hook::ViewListener
      def view_issues_show_details_bottom(context={})
        blocked = (context[:issue] && context[:issue].kanban_blocked?) ? l(:general_text_Yes) : l(:general_text_No)
        expedite = (context[:issue] && context[:issue].expedite?) ? l(:general_text_Yes) : l(:general_text_No)
        return content_tag(:tr,
                           content_tag(:th, l(:field_kanban_blocked), :class => 'kanban-blocked') +
                           content_tag(:td, blocked, :class => 'kanban-blocked') +
                           content_tag(:th, l(:field_expedite), :class => 'expedite') +
                           content_tag(:td, expedite, :class => 'expedite'))
                                       
      end
    end
  end
end
