module RedmineSimpleKanban
  module Hooks
    class ViewIssuesShowDescriptionBottomHook < Redmine::Hook::ViewListener
      def view_issues_show_description_bottom(context={})
        html = '<hr />'
        inner_section = ''
        inner_section << content_tag(:p, content_tag(:strong, l(:simple_kanban_text_skills_required)))

        if context[:issue].skill_list.present?
          inner_section << content_tag(:p,
                                       h(context[:issue].skill_list.to_s),
                                       :class => 'skill-list', :style => 'width: 100%')
          
          html << content_tag(:div, inner_section, :class => 'skills')

        end
        

        return html
      end
    end
  end
end
