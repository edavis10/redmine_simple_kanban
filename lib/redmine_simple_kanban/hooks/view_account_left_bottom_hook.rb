module RedmineSimpleKanban
  module Hooks
    class ViewAccountLeftBottomHook < Redmine::Hook::ViewListener
      # * :user
      def view_account_left_bottom(context={})
        return '' unless context[:user] && context[:user].skill_list.present?

        html = content_tag(:h3, l(:field_skill_list))
        html << content_tag(:ul,
                            context[:user].skill_list.sort.collect do |skill|
                              content_tag(:li, h(skill))
                            end,
                            :class => 'skills')
        html
      end
    end
  end
end
